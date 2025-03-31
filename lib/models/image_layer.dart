import 'dart:typed_data';

class ImageLayer {
  final String id;
  final String name;
  final Uint8List thumbnail;
  final Uint8List imageData;
  final bool isVisible;
  final double opacity;
  final BlendMode blendMode;

  const ImageLayer({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.imageData,
    this.isVisible = true,
    this.opacity = 1.0,
    this.blendMode = BlendMode.srcOver,
  });

  ImageLayer copyWith({
    String? name,
    Uint8List? thumbnail,
    Uint8List? imageData,
    bool? isVisible,
    double? opacity,
    BlendMode? blendMode,
  }) {
    return ImageLayer(
      id: id,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      imageData: imageData ?? this.imageData,
      isVisible: isVisible ?? this.isVisible,
      opacity: opacity ?? this.opacity,
      blendMode: blendMode ?? this.blendMode,
    );
  }
}

enum BlendMode {
  normal,
  multiply,
  screen,
  overlay,
  darken,
  lighten,
  colorDodge,
  colorBurn,
  hardLight,
  softLight,
  difference,
  exclusion,
  hue,
  saturation,
  color,
  luminosity,
}