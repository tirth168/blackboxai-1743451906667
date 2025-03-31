import 'package:flutter/material.dart';
import 'package:shutter/camera.dart';
import 'package:imagin/bloc/image_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late final CameraController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController();
    await _controller.initialize();
    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraPreview(_controller),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: _buildCameraControls(),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraControls() {
    return Column(
      children: [
        _buildManualControls(),
        const SizedBox(height: 20),
        FloatingActionButton(
          backgroundColor: Colors.tealAccent,
          onPressed: _captureImage,
          child: const Icon(Icons.camera, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildManualControls() {
    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildSliderControl(
              label: 'ISO',
              value: state.cameraIso,
              min: 100,
              max: 3200,
              onChanged: (v) => context.read<ImageBloc>().add(SetCameraIso(v)),
            ),
            _buildSliderControl(
              label: 'Exposure',
              value: state.cameraExposure,
              min: -3,
              max: 3,
              divisions: 6,
              onChanged: (v) => context.read<ImageBloc>().add(SetCameraExposure(v)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSliderControl({
    required String label,
    required double value,
    required double min,
    required double max,
    int? divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: Colors.tealAccent,
          ),
        ],
      ),
    );
  }

  Future<void> _captureImage() async {
    try {
      final image = await _controller.capture();
      if (image != null && mounted) {
        context.read<ImageBloc>().add(LoadImage(image));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Capture failed: $e')),
        );
      }
    }
  }
}