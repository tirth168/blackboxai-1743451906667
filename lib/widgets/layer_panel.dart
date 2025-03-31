import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin/bloc/image_bloc.dart';
import 'package:imagin/models/image_layer.dart';

class LayerPanel extends StatelessWidget {
  const LayerPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.black.withOpacity(0.8),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildLayerList(context)),
          _buildControls(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          const Icon(Icons.layers, color: Colors.white),
          const SizedBox(width: 8),
          const Text('Layers', style: TextStyle(color: Colors.white)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLayerList(BuildContext context) {
    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.layers.length,
          itemBuilder: (context, index) {
            return _buildLayerItem(context, state.layers[index], index);
          },
        );
      },
    );
  }

  Widget _buildLayerItem(BuildContext context, ImageLayer layer, int index) {
    final isActive = index == context.read<ImageBloc>().state.activeLayerIndex;
    return ListTile(
      tileColor: isActive ? Colors.teal.withOpacity(0.2) : null,
      leading: Checkbox(
        value: layer.isVisible,
        onChanged: (value) {},
        activeColor: Colors.tealAccent,
      ),
      title: Text(
        layer.name,
        style: TextStyle(
          color: isActive ? Colors.tealAccent : Colors.white,
        ),
      ),
      onTap: () {},
    );
  }

  Widget _buildControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.white,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}