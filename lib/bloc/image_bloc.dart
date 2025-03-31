import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_editing_app/services/ai_service.dart';
import 'package:image_editing_app/utils/image_utils.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final AIService aiService;
  final ImageUtils imageUtils;

  ImageBloc({
    required this.aiService,
    required this.imageUtils,
  }) : super(ImageState.initial()) {
    on<LoadImage>(_onLoadImage);
    on<ApplyFilter>(_onApplyFilter);
    on<GenerateAIImage>(_onGenerateAIImage);
    on<EnhanceImage>(_onEnhanceImage);
    on<UndoEdit>(_onUndoEdit);
    on<SaveImage>(_onSaveImage);
  }

  Future<void> _onLoadImage(LoadImage event, Emitter<ImageState> emit) async {
    emit(state.copyWith(
      currentImage: event.imageData,
      history: [...state.history, event.imageData],
      status: ImageStatus.ready,
    ));
  }

  Future<void> _onApplyFilter(ApplyFilter event, Emitter<ImageState> emit) async {
    if (state.currentImage == null) return;
    
    emit(state.copyWith(status: ImageStatus.loading));
    
    try {
      final filtered = await imageUtils.applyFilter(
        state.currentImage!,
        event.filterType,
        event.intensity,
      );
      emit(state.copyWith(
        currentImage: filtered,
        history: [...state.history, filtered],
        status: ImageStatus.ready,
        activeFilter: event.filterType,
        filterIntensity: event.intensity,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ImageStatus.error,
        errorMessage: 'Filter application failed: ${e.toString()}',
      ));
    }
  }

  Future<void> _onGenerateAIImage(GenerateAIImage event, Emitter<ImageState> emit) async {
    emit(state.copyWith(
      status: ImageStatus.loading,
      isAIProcessing: true,
    ));
    
    try {
      final image = await aiService.generateImage(event.prompt);
      emit(state.copyWith(
        currentImage: image,
        history: [...state.history, image],
        status: ImageStatus.ready,
        isAIProcessing: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ImageStatus.error,
        errorMessage: 'AI generation failed: ${e.toString()}',
        isAIProcessing: false,
      ));
    }
  }

  Future<void> _onEnhanceImage(EnhanceImage event, Emitter<ImageState> emit) async {
    if (state.currentImage == null) return;
    
    emit(state.copyWith(
      status: ImageStatus.loading,
      isAIProcessing: true,
    ));
    
    try {
      final enhanced = await aiService.enhanceImage(
        state.currentImage!,
        event.enhancementType,
      );
      emit(state.copyWith(
        currentImage: enhanced,
        history: [...state.history, enhanced],
        status: ImageStatus.ready,
        isAIProcessing: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ImageStatus.error,
        errorMessage: 'Enhancement failed: ${e.toString()}',
        isAIProcessing: false,
      ));
    }
  }

  void _onUndoEdit(UndoEdit event, Emitter<ImageState> emit) {
    if (state.history.length > 1) {
      final newHistory = List<Uint8List>.from(state.history)..removeLast();
      emit(state.copyWith(
        currentImage: newHistory.last,
        history: newHistory,
      ));
    }
  }

  Future<void> _onSaveImage(SaveImage event, Emitter<ImageState> emit) async {
    if (state.currentImage == null) return;
    
    emit(state.copyWith(status: ImageStatus.loading));
    
    try {
      await imageUtils.saveImage(state.currentImage!, event.fileName);
      emit(state.copyWith(status: ImageStatus.ready));
    } catch (e) {
      emit(state.copyWith(
        status: ImageStatus.error,
        errorMessage: 'Save failed: ${e.toString()}',
      ));
    }
  }
}