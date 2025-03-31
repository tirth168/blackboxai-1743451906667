import 'dart:typed_data';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  static Future<File> saveImage(Uint8List bytes, {String? fileName}) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = fileName ?? 'edit_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('${directory.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Uint8List applyFilter(Uint8List imageBytes, String filter) {
    final image = img.decodeImage(imageBytes)!;
    
    switch (filter) {
      case 'grayscale':
        return Uint8List.fromList(img.encodePng(img.grayscale(image)));
      case 'sepia':
        return Uint8List.fromList(img.encodePng(img.sepia(image)));
      case 'vintage':
        return Uint8List.fromList(img.encodePng(_applyVintageFilter(image)));
      case 'blur':
        return Uint8List.fromList(img.encodePng(img.gaussianBlur(image, 5)));
      default:
        return imageBytes;
    }
  }

  static img.Image _applyVintageFilter(img.Image image) {
    final vintage = img.copyResize(image, width: image.width, height: image.height);
    img.sepia(vintage);
    img.colorOffset(vintage, red: 10, green: -10);
    img.adjustColor(vintage, contrast: 0.9);
    return vintage;
  }

  static Future<Uint8List> mergeLayers(List<Uint8List> layers) async {
    if (layers.isEmpty) return Uint8List(0);
    if (layers.length == 1) return layers.first;

    img.Image? baseImage;
    for (final layer in layers) {
      final current = img.decodeImage(layer)!;
      if (baseImage == null) {
        baseImage = current;
      } else {
        baseImage = img.compositeImage(baseImage, current);
      }
    }

    return Uint8List.fromList(img.encodePng(baseImage!));
  }

  static Uint8List resizeImage(Uint8List imageBytes, int maxWidth) {
    final image = img.decodeImage(imageBytes)!;
    if (image.width <= maxWidth) return imageBytes;
    
    final ratio = image.height / image.width;
    final resized = img.copyResize(
      image,
      width: maxWidth,
      height: (maxWidth * ratio).round(),
    );
    return Uint8List.fromList(img.encodePng(resized));
  }
}