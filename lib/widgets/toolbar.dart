// create a floating toolbar

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
  List<bool> selected = [true, false, false, false];

  @override
  Widget build(BuildContext context) {
    List<Icon> buttons = [
      Icon(ref.read(boardProvider).tool.getIcon()),
      const Icon(Icons.delete_outline_outlined),
      const Icon(Icons.format_shapes_outlined),
      const Icon(Icons.cleaning_services_outlined),
      // restart here then delete old code latger
    ];
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
              isSelected: selected,
              onPressed: (index) {
                setState(() {
                  for (int i = 0; i < selected.length; i++) {
                    selected[i] = i == index;

                    if (index != 2) {
                      ref.read(boardProvider).toggleFrame();
                    }
                  }

                  if (index == 0) {
                    ref.read(boardProvider).tool = PenTool();
                  } else if (index == 1) {
                    ref.read(boardProvider).tool = EraserTool();
                  } else if (index == 2) {
                    ref.read(boardProvider).tool = ExtractorTool();
                    ref.read(boardProvider).extractText();
                  } else if (index == 3) {
                    ref.read(boardProvider.notifier).clear();
                    selected = [true, false, false, false];
                  }
                });
              },
              children: buttons),
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
