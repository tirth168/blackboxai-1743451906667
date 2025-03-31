from flask import Flask, request, jsonify, render_template, redirect, url_for
import torch
import cv2
import numpy as np
from werkzeug.utils import secure_filename
from ultralytics import YOLO
import joblib
import os
from datetime import datetime
import json
from PIL import Image
import io

# Initialize Flask app
app = Flask(__name__)

# Configuration
UPLOAD_FOLDER = 'static/uploads'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'mp4'}
MODEL_PATHS = {
    'cnn': 'models/cnn_model.pt',
    'xgboost': 'models/xgboost_model.pkl', 
    'yolo': 'models/yolov8_model.pt'
}

# Create upload folder
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# Load models
def load_models():
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    models = {}
    
    try:
        # Load CNN model
        from models.cnn_model import CNN  # Import your CNN model class
        cnn_model = CNN()  # Initialize with proper architecture
        cnn_model.load_state_dict(torch.load(MODEL_PATHS['cnn'], map_location=device))
        cnn_model.to(device)
        cnn_model.eval()
        models['cnn'] = cnn_model
        
        # Load XGBoost model
        models['xgboost'] = joblib.load(MODEL_PATHS['xgboost'])
        
        # Load YOLO model
        models['yolo'] = YOLO(MODEL_PATHS['yolo'])
        
        print("All models loaded successfully!")
        return models
    except Exception as e:
        print(f"Error loading models: {str(e)}")
        return None

# Initialize models
models = load_models()

# Helper functions
def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def preprocess_image(image):
    # Convert to RGB if needed
    if len(image.shape) == 2:
        image = cv2.cvtColor(image, cv2.COLOR_GRAY2RGB)
    elif image.shape[2] == 4:
        image = cv2.cvtColor(image, cv2.COLOR_BGRA2RGB)
    elif image.shape[2] == 1:
        image = cv2.cvtColor(image, cv2.COLOR_GRAY2RGB)
    
    # Resize and normalize
    image = cv2.resize(image, (256, 256))
    image = image / 255.0
    image = np.transpose(image, (2, 0, 1))
    image = torch.from_numpy(image).float().unsqueeze(0)
    return image

# Routes
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/detect', methods=['POST'])
def detect():
    if 'file' not in request.files:
        return jsonify({'error': 'No file uploaded'}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
        
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        filepath = os.path.join(UPLOAD_FOLDER, filename)
        file.save(filepath)
        
        try:
            # Image processing
            if filename.lower().endswith(('.png', '.jpg', '.jpeg')):
                image = cv2.imread(filepath)
                image = preprocess_image(image)
                
                # CNN prediction
                with torch.no_grad():
                    cnn_output = models['cnn'](image)
                    cnn_prob = torch.sigmoid(cnn_output).item()
                    cnn_pred = cnn_prob > 0.5
                
                # YOLO detection
                yolo_results = models['yolo'](filepath)
                yolo_pred = len(yolo_results[0].boxes) > 0
                
                # Combine predictions
                is_deepfake = cnn_pred or yolo_pred
                confidence = max(cnn_prob, 0.5 if yolo_pred else 0)
                
                # Prepare visualization
                annotated_img = yolo_results[0].plot()
                result_path = os.path.join(UPLOAD_FOLDER, f'result_{filename}')
                cv2.imwrite(result_path, annotated_img)
                
                return jsonify({
                    'is_deepfake': bool(is_deepfake),
                    'confidence': float(confidence),
                    'result_path': f'/static/uploads/result_{filename}',
                    'message': 'Deepfake detected' if is_deepfake else 'Authentic media'
                })
            
            # Video processing
            elif filename.lower().endswith('.mp4'):
                # Implement video processing logic
                return jsonify({
                    'is_deepfake': False,
                    'confidence': 0.0,
                    'message': 'Video processing not yet implemented'
                })
                
        except Exception as e:
            return jsonify({'error': str(e)}), 500
    
    return jsonify({'error': 'Invalid file type'}), 400

@app.route('/dashboard')
def dashboard():
    try:
        with open('metrics/metrics.json') as f:
            metrics = json.load(f)
        return render_template('dashboard.html', metrics=metrics)
    except FileNotFoundError:
        return render_template('dashboard.html', metrics=None)

@app.route('/api/metrics')
def get_metrics():
    try:
        with open('metrics/metrics.json') as f:
            metrics = json.load(f)
        return jsonify(metrics)
    except FileNotFoundError:
        return jsonify({'error': 'Metrics not available'}), 404

@app.route('/api/gpu-status')
def gpu_status():
    status = {
        'gpu_available': torch.cuda.is_available(),
        'device': str(torch.device('cuda' if torch.cuda.is_available() else 'cpu'))
    }
    if torch.cuda.is_available():
        status.update({
            'memory_used': f"{torch.cuda.memory_allocated()/1024**3:.1f}GB",
            'memory_total': f"{torch.cuda.get_device_properties(0).total_memory/1024**3:.1f}GB"
        })
    return jsonify(status)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)