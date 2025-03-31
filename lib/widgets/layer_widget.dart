import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_editing_app/bloc/image_bloc.dart';

class LayerWidget extends StatelessWidget {
  const LayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        return Container(
          width: 200,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Layers',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              ...state.imageLayers.asMap().entries.map((entry) {
                final index = entry.key;
                return _LayerItem(
                  index: index,
                  isActive: index == state.imageLayers.length - 1,
                );
              }).toList(),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: () {
                      // TODO: Implement add new layer
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: () {
                      // TODO: Implement delete layer
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LayerItem extends StatelessWidget {
  final int index;
  final bool isActive;

  const _LayerItem({
    required this.index,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListTile(
        dense: true,
        leading: const Icon(Icons.layers, size: 20),
        title: Text('Layer ${index + 1}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility, size: 16),
              onPressed: () {
                // TODO: Implement toggle visibility
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, size: 16),
              onPressed: () {
                // TODO: Implement layer options
              },
            ),
          ],
        ),
      ),
    );
  }
}