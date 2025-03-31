import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_editing_app/bloc/image_bloc.dart';

class PropertyPanel extends StatelessWidget {
  const PropertyPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.currentTool == 'brush') ...[
                const Text('Brush Size'),
                Slider(
                  value: state.brushSize,
                  min: 1,
                  max: 50,
                  onChanged: (value) => context.read<ImageBloc>().add(
                    SetBrushSize(value),
                  ),
                ),
                const Text('Opacity'),
                Slider(
                  value: state.brushOpacity,
                  min: 0.1,
                  max: 1,
                  onChanged: (value) => context.read<ImageBloc>().add(
                    SetBrushOpacity(value),
                  ),
                ),
              ],
              if (state.currentTool == 'text') ...[
                const Text('Font Size'),
                Slider(
                  value: state.fontSize,
                  min: 8,
                  max: 72,
                  onChanged: (value) => context.read<ImageBloc>().add(
                    SetFontSize(value),
                  ),
                ),
              ],
              if (state.currentTool == 'filter') ...[
                const Text('Intensity'),
                Slider(
                  value: state.filterIntensity,
                  min: 0,
                  max: 1,
                  onChanged: (value) => context.read<ImageBloc>().add(
                    SetFilterIntensity(value),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}