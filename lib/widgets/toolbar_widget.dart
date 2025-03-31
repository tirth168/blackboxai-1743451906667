import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_editing_app/bloc/image_bloc.dart';

class ToolbarWidget extends StatelessWidget {
  const ToolbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      color: Colors.grey[200],
      child: Column(
        children: [
          _ToolButton(
            icon: Icons.brush,
            toolName: 'brush',
            onPressed: () => context.read<ImageBloc>().add(SetTool('brush')),
          ),
          _ToolButton(
            icon: Icons.text_fields,
            toolName: 'text',
            onPressed: () => context.read<ImageBloc>().add(SetTool('text')),
          ),
          _ToolButton(
            icon: Icons.filter,
            toolName: 'filter',
            onPressed: () => context.read<ImageBloc>().add(SetTool('filter')),
          ),
          _ToolButton(
            icon: Icons.layers,
            toolName: 'layers',
            onPressed: () => context.read<ImageBloc>().add(SetTool('layers')),
          ),
          const Divider(),
          _ToolButton(
            icon: Icons.auto_awesome,
            toolName: 'ai',
            onPressed: () => _showAIMenu(context),
          ),
        ],
      ),
    );
  }

  void _showAIMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.auto_fix_high),
            title: const Text('Remove Background'),
            onTap: () {
              Navigator.pop(context);
              context.read<ImageBloc>().add(ApplyAIEnhancement());
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Style Transfer'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement style transfer
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome_motion),
            title: const Text('Enhance Image'),
            onTap: () {
              Navigator.pop(context);
              context.read<ImageBloc>().add(ApplyAIEnhancement());
            },
          ),
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String toolName;
  final VoidCallback onPressed;

  const _ToolButton({
    required this.icon,
    required this.toolName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        return IconButton(
          icon: Icon(icon),
          color: state.currentTool == toolName ? Colors.blue : Colors.black,
          onPressed: onPressed,
        );
      },
    );
  }
}