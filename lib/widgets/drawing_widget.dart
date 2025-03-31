import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_editing_app/bloc/image_bloc.dart';

class DrawingWidget extends StatefulWidget {
  final Size canvasSize;

  const DrawingWidget({
    super.key,
    required this.canvasSize,
  });

  @override
  State<DrawingWidget> createState() => _DrawingWidgetState();
}

class _DrawingWidgetState extends State<DrawingWidget> {
  final List<Offset> _points = [];
  double _brushSize = 5.0;
  Color _brushColor = Colors.black;
  double _brushOpacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          _points.add(details.localPosition);
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _points.add(details.localPosition);
        });
      },
      onPanEnd: (details) {
        _commitDrawing();
        _points.clear();
      },
      child: CustomPaint(
        size: widget.canvasSize,
        painter: _DrawingPainter(
          points: _points,
          brushSize: _brushSize,
          brushColor: _brushColor.withOpacity(_brushOpacity),
        ),
      ),
    );
  }

  void _commitDrawing() {
    if (_points.isEmpty) return;
    
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()
      ..color = _brushColor.withOpacity(_brushOpacity)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _brushSize;

    for (int i = 0; i < _points.length - 1; i++) {
      if (_points[i] != null && _points[i + 1] != null) {
        canvas.drawLine(_points[i], _points[i + 1], paint);
      }
    }

    final picture = recorder.endRecording();
    final image = picture.toImage(
      widget.canvasSize.width.toInt(),
      widget.canvasSize.height.toInt(),
    );

    image.toByteData(format: ImageByteFormat.png).then((byteData) {
      if (byteData != null) {
        context.read<ImageBloc>().add(
          AddDrawingLayer(byteData.buffer.asUint8List()),
        );
      }
    });
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Offset> points;
  final double brushSize;
  final Color brushColor;

  const _DrawingPainter({
    required this.points,
    required this.brushSize,
    required this.brushColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = brushColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = brushSize;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DrawingPainter oldDelegate) => true;
}