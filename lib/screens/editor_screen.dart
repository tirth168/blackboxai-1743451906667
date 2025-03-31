import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinematic_image_editor/bloc/image_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shutter/camera.dart';
import 'package:cinematic_image_editor/widgets/filter_toolbar.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final _cameraController = CameraController();

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Cinematic Editor'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _openCamera,
            color: Colors.tealAccent,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveImage(context),
            color: Colors.tealAccent,
          ),
        ],
      ),
      body: BlocBuilder<ImageBloc, ImageState>(
        builder: (context, state) {
          if (state.currentImage == null) {
            return _buildEmptyState();
          }
          return Stack(
            children: [
              PhotoView(
                imageProvider: MemoryImage(state.currentImage!),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.black,
                ),
              ),
              if (state.status == ImageStatus.loading)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
      bottomNavigationBar: const FilterToolbar(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No image loaded',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
            ),
            onPressed: _openCamera,
            child: const Text('Open Camera'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
            ),
            onPressed: () => _loadFromGallery(context),
            child: const Text('Load from Gallery'),
          ),
        ],
      ),
    );
  }

  void _openCamera() async {
    // TODO: Implement camera opening logic
  }

  void _loadFromGallery(BuildContext context) {
    // TODO: Implement gallery loading
  }

  void _saveImage(BuildContext context) {
    final bloc = context.read<ImageBloc>();
    bloc.add(SaveImage('edited_${DateTime.now().millisecondsSinceEpoch}.jpg'));
  }
}