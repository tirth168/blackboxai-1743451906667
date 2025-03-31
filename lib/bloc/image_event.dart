part of 'image_bloc.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class LoadImage extends ImageEvent {
  final Uint8List imageData;
  const LoadImage(this.imageData);

  @override
  List<Object> get props => [imageData];
}

class ApplyFilter extends ImageEvent {
  final String filterType;
  final double intensity;
  const ApplyFilter(this.filterType, this.intensity);

  @override
  List<Object> get props => [filterType, intensity];
}

class GenerateAIImage extends ImageEvent {
  final String prompt;
  const GenerateAIImage(this.prompt);

  @override
  List<Object> get props => [prompt];
}

class EnhanceImage extends ImageEvent {
  final String enhancementType;
  const EnhanceImage(this.enhancementType);

  @override
  List<Object> get props => [enhancementType];
}

class UndoEdit extends ImageEvent {}

class SaveImage extends ImageEvent {
  final String fileName;
  const SaveImage(this.fileName);

  @override
  List<Object> get props => [fileName];
}