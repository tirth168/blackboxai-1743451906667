import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_editing_app/bloc/image_bloc.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        if (state.imageLayers.isEmpty) {
          return const Center(child: Text('No image loaded'));
        }

        return GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: [
            _FilterThumbnail(
              name: 'Original',
              imageBytes: state.imageLayers.last,
              onTap: () => context.read<ImageBloc>().add(
                ApplyFilter('none'),
              ),
            ),
            _FilterThumbnail(
              name: 'Grayscale',
              imageBytes: state.imageLayers.last,
              filter: 'grayscale',
              onTap: () => context.read<ImageBloc>().add(
                ApplyFilter('grayscale'),
              ),
            ),
            _FilterThumbnail(
              name: 'Sepia',
              imageBytes: state.imageLayers.last,
              filter: 'sepia',
              onTap: () => context.read<ImageBloc>().add(
                ApplyFilter('sepia'),
              ),
            ),
            _FilterThumbnail(
              name: 'Vintage',
              imageBytes: state.imageLayers.last,
              filter: 'vintage',
              onTap: () => context.read<ImageBloc>().add(
                ApplyFilter('vintage'),
              ),
            ),
            _FilterThumbnail(
              name: 'Blur',
              imageBytes: state.imageLayers.last,
              filter: 'blur',
              onTap: () => context.read<ImageBloc>().add(
                ApplyFilter('blur'),
              ),
            ),
            _FilterThumbnail(
              name: 'AI Enhance',
              imageBytes: state.imageLayers.last,
              isAI: true,
              onTap: () => context.read<ImageBloc>().add(
                ApplyAIEnhancement(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FilterThumbnail extends StatelessWidget {
  final String name;
  final Uint8List imageBytes;
  final String? filter;
  final bool isAI;
  final VoidCallback onTap;

  const _FilterThumbnail({
    required this.name,
    required this.imageBytes,
    this.filter,
    this.isAI = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (filter != null)
                    FutureBuilder<Uint8List>(
                      future: _applyFilter(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  if (filter == null && !isAI)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        imageBytes,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (isAI)
                    const Center(
                      child: Icon(Icons.auto_awesome, size: 40),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _applyFilter() async {
    if (filter == null) return imageBytes;
    // TODO: Implement actual filter application
    return imageBytes;
  }
}