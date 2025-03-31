part of 'image_bloc.dart';

enum ImageStatus { initial, loading, ready, error }

class ImageState extends Equatable {
  final Uint8List? currentImage;
  final List<Uint8List> history;
  final ImageStatus status;
  final String? errorMessage;
  final String activeFilter;
  final double filterIntensity;
  final bool isAIProcessing;

  const ImageState({
    this.currentImage,
    this.history = const [],
    this.status = ImageStatus.initial,
    this.errorMessage,
    this.activeFilter = 'none',
    this.filterIntensity = 0.5,
    this.isAIProcessing = false,
  });

  ImageState copyWith({
    Uint8List? currentImage,
    List<Uint8List>? history,
    ImageStatus? status,
    String? errorMessage,
    String? activeFilter,
    double? filterIntensity,
    bool? isAIProcessing,
  }) {
    return ImageState(
      currentImage: currentImage ?? this.currentImage,
      history: history ?? this.history,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      activeFilter: activeFilter ?? this.activeFilter,
      filterIntensity: filterIntensity ?? this.filterIntensity,
      isAIProcessing: isAIProcessing ?? this.isAIProcessing,
    );
  }

  @override
  List<Object?> get props => [
        currentImage,
        history,
        status,
        errorMessage,
        activeFilter,
        filterIntensity,
        isAIProcessing,
      ];
}