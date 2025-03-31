enum DrawingTool {
  brush,
  pencil,
  eraser,
  fill,
  gradient,
  shape,
  text,
}

class BrushSettings {
  final double size;
  final double opacity;
  final double hardness;
  final Color color;

  const BrushSettings({
    this.size = 10.0,
    this.opacity = 1.0,
    this.hardness = 0.9,
    this.color = Colors.black,
  });

  BrushSettings copyWith({
    double? size,
    double? opacity,
    double? hardness,
    Color? color,
  }) {
    return BrushSettings(
      size: size ?? this.size,
      opacity: opacity ?? this.opacity,
      hardness: hardness ?? this.hardness,
      color: color ?? this.color,
    );
  }
}

class ShapeTool {
  final ShapeType type;
  final bool fill;
  final double strokeWidth;

  const ShapeTool({
    this.type = ShapeType.rectangle,
    this.fill = false,
    this.strokeWidth = 2.0,
  });
}

enum ShapeType {
  rectangle,
  circle,
  line,
  polygon,
}