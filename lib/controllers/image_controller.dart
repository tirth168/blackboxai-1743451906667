import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:image_editing_app/utils/image_utils.dart';

class ImageController {
  Future<Uint8List> cropImage(
    Uint8List imageBytes,
    int x,
    int y,
    int width,
    int height,
  ) async {
    final image = img.decodeImage(imageBytes)!;
    final cropped = img.copyCrop(image, x: x, y: y, width: width, height: height);
    return Uint8List.fromList(img.encodePng(cropped));
  }

  Future<Uint8List> rotateImage(Uint8List imageBytes, double degrees) async {
    final image = img.decodeImage(imageBytes)!;
    final rotated = img.copyRotate(image, angle: degrees);
    return Uint8List.fromList(img.encodePng(rotated));
  }

  Future<Uint8List> flipImage(Uint8List imageBytes, bool horizontal) async {
    final image = img.decodeImage(imageBytes)!;
    final flipped = horizontal ? img.flipHorizontal(image) : img.flipVertical(image);
    return Uint8List.fromList(img.encodePng(flipped));
  }

  Future<Uint8List> adjustBrightness(
    Uint8List imageBytes,
    double value,
  ) async {
    final image = img.decodeImage(imageBytes)!;
    final adjusted = img.adjustColor(
      image,
      brightness: value.clamp(-1.0, 1.0).toDouble(),
    );
    return Uint8List.fromList(img.encodePng(adjusted));
  }

  Future<Uint8List> adjustContrast(
    Uint8List imageBytes,
    double value,
  ) async {
    final image = img.decodeImage(imageBytes)!;
    final adjusted = img.adjustColor(
      image,
      contrast: value.clamp(0.0, 2.0).toDouble(),
    );
    return Uint8List.fromList(img.encodePng(adjusted));
  }

  Future<Uint8List> adjustSaturation(
    Uint8List imageBytes,
    double value,
  ) async {
    final image = img.decodeImage(imageBytes)!;
    final adjusted = img.adjustColor(
      image,
      saturation: value.clamp(0.0, 2.0).toDouble(),
    );
    return Uint8List.fromList(img.encodePng(adjusted));
  }

  Future<Uint8List> resizeImage(
    Uint8List imageBytes,
    int width,
    int height,
  ) async {
    return ImageUtils.resizeImage(imageBytes, width);
  }

  Future<Uint8List> compressImage(
    Uint8List imageBytes,
    int quality,
  ) async {
    final image = img.decodeImage(imageBytes)!;
    return Uint8List.fromList(img.encodeJpg(image, quality: quality));
  }
}