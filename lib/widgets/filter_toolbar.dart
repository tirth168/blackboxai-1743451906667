import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinematic_image_editor/bloc/image_bloc.dart';

class FilterToolbar extends StatelessWidget {
  const FilterToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        border: const Border(
          top: BorderSide(color: Colors.tealAccent, width: 0.5),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                FilterOption(name: 'Original', filter: 'none'),
                FilterOption(name: 'Cinematic', filter: 'cinematic'),
                FilterOption(name: 'Noir', filter: 'noir'),
                FilterOption(name: 'Vintage', filter: 'vintage'),
                FilterOption(name: 'Neon', filter: 'neon'),
                FilterOption(name: 'HDR', filter: 'hdr'),
                FilterOption(name: 'Mono', filter: 'mono'),
              ],
            ),
          ),
          BlocBuilder<ImageBloc, ImageState>(
            builder: (context, state) {
              return Slider(
                value: state.filterIntensity,
                min: 0,
                max: 1,
                divisions: 10,
                onChanged: (value) {
                  context.read<ImageBloc>().add(
                    ApplyFilter(state.activeFilter, value),
                  );
                },
                activeColor: Colors.tealAccent,
                inactiveColor: Colors.tealAccent.withOpacity(0.3),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FilterOption extends StatelessWidget {
  final String name;
  final String filter;

  const FilterOption({
    super.key,
    required this.name,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        final isActive = state.activeFilter == filter;
        return GestureDetector(
          onTap: () {
            context.read<ImageBloc>().add(
              ApplyFilter(filter, state.filterIntensity),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isActive 
                  ? Colors.tealAccent.withOpacity(0.2)
                  : Colors.transparent,
              border: Border.all(
                color: isActive ? Colors.tealAccent : Colors.grey[700]!,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.filter_b_and_w,
                  color: isActive ? Colors.tealAccent : Colors.white,
                  size: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: TextStyle(
                    color: isActive ? Colors.tealAccent : Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}