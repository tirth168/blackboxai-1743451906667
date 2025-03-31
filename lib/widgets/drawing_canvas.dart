import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin/models/drawing_tool.dart';
import 'package:imagin/bloc/image_bloc.dart';

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key});

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  final _painter = DrawingPainter();
  Offset? _currentPosition;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        return GestureDetector(
          onPanStart: _handlePanStart,
          onPanUpdate: _handlePanUpdate,
          onPanEnd: _handlePanEnd,
          child: CustomPaint(
            painter: _painter,
            size: Size.infinite,
          ),
        );
      },
    );
  }

  void _handlePanStart(DragStartDetails details) {
    _currentPosition = details.localPosition;
    _startNewStroke();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    _currentPosition = details.localPosition;
    _addPointToStroke();
  }

  void _handlePanEnd(DragEndDetails details) {
    _finalizeStroke();
  }

  void _startNewStroke() {
    final state = context.read<ImageBloc>().state;
    context.read<ImageBloc>().add(
      StartStroke(
        tool: state.activeTool,
        settings: state.brushSettings,
        position: _currentPosition!,
      ),
    );
  }

  void _addPointToStroke() {
    context.read<ImageBloc>().add(
      AddStrokePoint(_currentPosition!),
    );
  }

  void _finalizeStroke() {
    context.read<ImageBloc>().add(const EndStroke());
  }
}

class DrawingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Implement drawing logic
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}