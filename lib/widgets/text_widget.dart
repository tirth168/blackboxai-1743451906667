import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_editing_app/bloc/image_bloc.dart';

class TextWidget extends StatefulWidget {
  final Size canvasSize;

  const TextWidget({
    super.key,
    required this.canvasSize,
  });

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  final TextEditingController _textController = TextEditingController();
  Offset _position = const Offset(100, 100);
  double _fontSize = 24;
  Color _textColor = Colors.black;
  String _fontFamily = 'Roboto';
  bool _hasShadow = false;
  bool _hasStroke = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_textController.text.isNotEmpty)
          Positioned(
            left: _position.dx,
            top: _position.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _position += details.delta;
                });
              },
              child: Text(
                _textController.text,
                style: TextStyle(
                  fontSize: _fontSize,
                  color: _textColor,
                  fontFamily: _fontFamily,
                  shadows: _hasShadow
                      ? [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(2, 2),
                          )
                        ]
                      : null,
                  foreground: _hasStroke
                      ? Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.white
                      : null,
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildTextControls(),
        ),
      ],
    );
  }

  Widget _buildTextControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Enter Text',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Size:'),
              Expanded(
                child: Slider(
                  value: _fontSize,
                  min: 8,
                  max: 72,
                  onChanged: (value) => setState(() => _fontSize = value),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.format_color_text),
                onPressed: () => _showColorPicker(),
              ),
              IconButton(
                icon: const Icon(Icons.font_download),
                onPressed: () => _showFontPicker(),
              ),
              IconButton(
                icon: const Icon(Icons.shadow),
                onPressed: () => setState(() => _hasShadow = !_hasShadow),
              ),
              IconButton(
                icon: const Icon(Icons.border_color),
                onPressed: () => setState(() => _hasStroke = !_hasStroke),
              ),
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: _commitText,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Text Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _textColor,
            onColorChanged: (color) => setState(() => _textColor = color),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFontPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Font'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FontOption(
              fontFamily: 'Roboto',
              isSelected: _fontFamily == 'Roboto',
              onSelected: () => setState(() => _fontFamily = 'Roboto'),
            ),
            _FontOption(
              fontFamily: 'Arial',
              isSelected: _fontFamily == 'Arial',
              onSelected: () => setState(() => _fontFamily = 'Arial'),
            ),
            // Add more font options as needed
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _commitText() {
    if (_textController.text.isEmpty) return;

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final textPainter = TextPainter(
      text: TextSpan(
        text: _textController.text,
        style: TextStyle(
          fontSize: _fontSize,
          color: _textColor,
          fontFamily: _fontFamily,
          shadows: _hasShadow
              ? [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(2, 2),
                  )
                ]
              : null,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, _position);

    final picture = recorder.endRecording();
    final image = picture.toImage(
      widget.canvasSize.width.toInt(),
      widget.canvasSize.height.toInt(),
    );

    image.toByteData(format: ImageByteFormat.png).then((byteData) {
      if (byteData != null) {
        context.read<ImageBloc>().add(
          AddTextLayer(
            _textController.text,
            TextStyle(
              fontSize: _fontSize,
              color: _textColor,
              fontFamily: _fontFamily,
              shadows: _hasShadow
                  ? [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(2, 2),
                      )
                    ]
                  : null,
            ),
            _position,
            byteData.buffer.asUint8List(),
          ),
        );
        _textController.clear();
      }
    });
  }
}

class _FontOption extends StatelessWidget {
  final String fontFamily;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FontOption({
    required this.fontFamily,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        fontFamily,
        style: TextStyle(
          fontFamily: fontFamily,
          color: isSelected ? Colors.blue : Colors.black,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check) : null,
      onTap: onSelected,
    );
  }
}