import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treboard/models/draw_mode.dart';
import 'package:treboard/providers/board_provider.dart';

class Toolbar extends ConsumerStatefulWidget {
  const Toolbar({super.key});

  @override
  ConsumerState<Toolbar> createState() => _ToolbarState();
}

class Tool {
  final DrawMode tool;
  Icon icon;

  Tool(this.tool, this.icon);
}

class _ToolbarState extends ConsumerState<Toolbar> {
  // create dict of icons and their respective tool

  List<Tool> tools = [
// sketch, erase
    Tool(DrawMode.sketch, const Icon(Icons.edit_outlined)),
    Tool(DrawMode.erase, const Icon(Icons.delete_outline_outlined)),
    Tool(DrawMode.clear, const Icon(Icons.clear_outlined)),
  ];

  List<Tool> shapeTools = [
    Tool(DrawMode.sketch, const Icon(Icons.edit_outlined)),
    Tool(DrawMode.line, const Icon(Icons.horizontal_rule_outlined)),
    Tool(DrawMode.circle, const Icon(Icons.circle_outlined)),
    Tool(DrawMode.square, const Icon(Icons.crop_square_outlined)),
  ];

  bool isSketchToolsVisible = false;

  @override
  Widget build(BuildContext context) {
    // based on what the current tool is, set the selected button
    List<bool> selected = List.filled(tools.length, false);
    List<bool> shapeSelected = List.filled(shapeTools.length, false);

    for (int i = 0; i < tools.length; i++) {
      if (tools[i].tool == ref.watch(boardProvider).drawingMode) {
        selected[i] = true;
      }
    }

    for (int i = 0; i < shapeTools.length; i++) {
      if (shapeTools[i].tool == ref.watch(boardProvider).drawingMode) {
        shapeSelected[i] = true;

        // if the current tool is a shape tool, change the sketch tool icon to that
        // tool
        if (ref.watch(boardProvider).drawingMode != DrawMode.sketch) {
          tools[0].icon = shapeTools[i].icon;
        } else {
          tools[0].icon = const Icon(Icons.edit_outlined);
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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
                  constraints:
                      const BoxConstraints(minWidth: 50, minHeight: 50),
                  direction: Axis.vertical,
                  fillColor: Colors.grey[200],
                  isSelected: selected,
                  onPressed: (index) {
                    // set the selected tool
                    if (tools[index].tool != DrawMode.clear) {
                      ref
                          .read(boardProvider.notifier)
                          .setMode(tools[index].tool);
                    } else {
                      ref.read(boardProvider).clearBoard();
                    }
                    // set the selected button if not the sketch tool
                    if (index != 0) {
                      selected = List.filled(tools.length, false);
                      selected[index] = true;
                    }

                    setState(() {
                      isSketchToolsVisible = index == 0;
                      selected = selected;
                    });
                  },
                  children: tools
                      .map((tool) => Container(
                            child: tool.icon,
                          ))
                      .toList()),
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
                        color: ref.read(boardProvider).allStrokes.isNotEmpty
                            ? Colors.black
                            : Colors.grey),
                    onPressed: () {
                      // remove the last stroke
                      ref.read(boardProvider).allStrokes.isNotEmpty
                          ? ref.read(boardProvider).undo()
                          : null;
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.redo_outlined,
                        color: ref.watch(boardProvider).canRedo
                            ? Colors.black
                            : Colors.grey),
                    onPressed: () {
                      // redo the last stroke
                      ref.watch(boardProvider).canRedo
                          ? ref.read(boardProvider).redo()
                          : null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 10),
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
          child: Visibility(
            visible: isSketchToolsVisible,
            child: ToggleButtons(
                constraints: const BoxConstraints(minWidth: 50, minHeight: 50),
                direction: Axis.vertical,
                fillColor: Colors.grey[200],
                isSelected: shapeSelected,
                onPressed: (index) {
                  // set the selected tool
                  ref
                      .read(boardProvider.notifier)
                      .setMode(shapeTools[index].tool);

                  // set the selected button
                  for (int i = 0; i < shapeSelected.length; i++) {
                    shapeSelected[i] = i == index;
                  }
                },
                children: shapeTools
                    .map((tool) => Container(
                          child: tool.icon,
                        ))
                    .toList()),
          ),
        ),
      ],
    );
  }
}
