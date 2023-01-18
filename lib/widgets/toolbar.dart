// create a floating toolbar

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gehenna/core/tool.dart';
import 'package:gehenna/providers/board_provider.dart';
import 'package:gehenna/widgets/color_bar.dart';

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
                tooltip: 'Pen tool',
                icon: Icon(ref.read(boardProvider).tool.getIcon()),
                color: ref.watch(boardProvider).penColor,
                onPressed: () {
                  ref.watch(boardProvider).tool = PenTool();
                },
              ),
              IconButton(
                tooltip: 'Eraser tool',
                icon: const Icon(Icons.delete_outline_outlined),
                color: ThemeData.dark().canvasColor,
                onPressed: () {
                  ref.watch(boardProvider).tool = EraserTool();
                },
              ),
              IconButton(
                tooltip: 'Evaluate canvas expression',
                icon: const Icon(Icons.format_shapes_outlined),
                onPressed: () {
                  ref.watch(boardProvider).tool = ExtractorTool();
                  ref.watch(boardProvider).extractText();
                },
              ),
              IconButton(
                tooltip: 'Clear canvas',
                icon: const Icon(Icons.cleaning_services_outlined),
                onPressed: () {
                  // clear the board
                  ref.read(boardProvider.notifier).clear();
                },
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
                onPressed: () {
                  // redo the last stroke
                  ref.read(boardProvider.notifier).redo();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
