// create a floating toolbar

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treboard/core/tool.dart';
import 'package:treboard/providers/board_provider.dart';

class Toolbar extends ConsumerStatefulWidget {
  const Toolbar({super.key});

  @override
  ConsumerState<Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends ConsumerState<Toolbar> {
  // create dict of icons and their respective tool

  List<Tool> tools = [
    PenTool(),
    EraserTool(),
    ExtractorTool(),
    ClearTool(),
  ];

  List<Icon> icons = [
    const Icon(Icons.edit_outlined),
    const Icon(Icons.delete_outline_outlined),
    const Icon(Icons.format_shapes_outlined),
    const Icon(Icons.cleaning_services_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    // based on what the current tool is, set the selected button
    List<bool> selected = List.filled(tools.length, false);
    for (int i = 0; i < tools.length; i++) {
      if (ref.watch(boardProvider).tool == tools[i]) {
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
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ToggleButtons(
              direction: Axis.vertical,
              fillColor: Colors.grey[200],
              isSelected: selected,
              onPressed: (index) {
                if (tools[index] is ClearTool) {
                  // clear the board
                  ref.read(boardProvider).clearBoard();
                  index = 0;
                  return;
                }
                // set the selected tool
                ref.read(boardProvider.notifier).setTool(tools[index]);
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
                    color: ref.watch(boardProvider).state.canUndo
                        ? Colors.black
                        : Colors.grey),
                onPressed: () {
                  // remove the last stroke
                  ref.read(boardProvider.notifier).undo();
                },
              ),
              IconButton(
                icon: Icon(Icons.redo_outlined,
                    color: ref.watch(boardProvider).state.canRedo
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
