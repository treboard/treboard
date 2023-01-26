// create a floating toolbar

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treboard/models/draw_mode.dart';
import 'package:treboard/providers/board_provider.dart';

class Toolbar extends ConsumerStatefulWidget {
  const Toolbar({super.key});

  @override
  ConsumerState<Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends ConsumerState<Toolbar> {
  // create dict of icons and their respective tool

  List<DrawMode> tools = [
    DrawMode.sketch,
    DrawMode.erase,
    DrawMode.line,
  ];

  List<Icon> icons = [
    const Icon(Icons.edit_outlined),
    const Icon(Icons.delete_outline_outlined),
    const Icon(Icons.format_shapes_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    // based on what the current tool is, set the selected button
    List<bool> selected = List.filled(tools.length, false);
    for (int i = 0; i < tools.length; i++) {
      if (ref.watch(boardProvider).drawingMode == tools[i]) {
        selected[i] = true;
      }
    }

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
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ToggleButtons(
              constraints: const BoxConstraints(minWidth: 50, minHeight: 50),
              direction: Axis.vertical,
              fillColor: Colors.grey[200],
              isSelected: selected,
              onPressed: (index) {
                // set the selected tool
                ref.read(boardProvider.notifier).setMode(tools[index]);
                // set the selected button
                for (int i = 0; i < selected.length; i++) {
                  selected[i] = i == index;
                }
                setState(() {
                  selected = selected;
                });
              },
              children: icons),
        ),
        Container(
          width: 50,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          // space between the two columns

          child: Column(
            children: [
              IconButton(
                icon: Icon(Icons.undo_outlined,
                    color: ref.watch(boardProvider).canUndo
                        ? Colors.black
                        : Colors.grey),
                onPressed: () {
                  // remove the last stroke
                  ref.read(boardProvider.notifier).undo();
                },
              ),
              IconButton(
                icon: Icon(Icons.redo_outlined,
                    color: ref.watch(boardProvider).canRedo
                        ? Colors.black
                        : Colors.grey),
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
