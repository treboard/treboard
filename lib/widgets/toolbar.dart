// create a floating toolbar

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gehenna/core/tool.dart';
import 'package:gehenna/providers/board.dart';

class Toolbar extends ConsumerStatefulWidget {
  const Toolbar({super.key});

  @override
  ConsumerState<Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends ConsumerState<Toolbar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              IconButton(
                icon: Icon(ref.read(boardProvider).tool.getIcon()),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.format_shapes_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.cleaning_services_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          // space between the two columns
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              IconButton(
                icon: const Icon(Icons.undo_outlined),
                onPressed: () {
                  // remove the last stroke
                  ref.read(boardProvider.notifier).undo();
                },
              ),
              IconButton(
                icon: const Icon(Icons.redo_outlined),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}