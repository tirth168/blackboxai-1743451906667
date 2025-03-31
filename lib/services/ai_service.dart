import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image_editing_app/utils/image_utils.dart';

class AIService {
  final Dio _dio;
  final ImageUtils _imageUtils;

  AIService(this._imageUtils) : _dio = Dio(BaseOptions(
    baseUrl: 'https://api.openai.com/v1/',
    headers: {'Authorization': 'Bearer YOUR_OPENAI_KEY'},
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  Future<Uint8List> generateImage(String prompt) async {
    try {
      final response = await _dio.post(
        'images/generations',
        data: {
          'prompt': prompt,
          'n': 1,
          'size': '1024x1024',
          'response_format': 'b64_json',
        },
      );

      final imageData = response.data['data'][0]['b64_json'];
      return _imageUtils.base64ToImage(imageData);
    } on DioException catch (e) {
      throw Exception('API request failed: ${e.message}');
    } catch (e) {
      throw Exception('Image generation failed: $e');
    }
  }

  Future<Uint8List> enhanceImage(
    Uint8List image, 
    String enhancementType,
  ) async {
    try {
      switch (enhancementType) {
        case 'upscale':
          return await _imageUtils.upscaleImage(image);
        case 'denoise':
          return await _imageUtils.denoiseImage(image);
        case 'color_correct':
          return await _imageUtils.colorCorrectImage(image);
        case 'background_remove':
          return await _imageUtils.removeBackground(image);
        default:
          throw Exception('Unsupported enhancement type');
      }
    } catch (e) {
      throw Exception('Enhancement failed: $e');
    }
  }

  Future<Uint8List> applyStyleTransfer(
    Uint8List contentImage,
    Uint8List styleImage,
  ) async {
    try {
      final formData = FormData.fromMap({
        'content': MultipartFile.fromBytes(contentImage),
        'style': MultipartFile.fromBytes(styleImage),
      });

      final response = await _dio.post(
        'style-transfer',
        data: formData,
      );

      return Uint8List.fromList(response.data);
    } catch (e) {
      throw Exception('Style transfer failed: $e');
    }
  }
}