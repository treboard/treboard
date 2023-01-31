import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:treboard/providers/board_provider.dart';
import 'package:treboard/providers/node_provider.dart';
import 'package:treboard/widgets/board_canvas.dart';
import 'package:treboard/widgets/color_bar.dart';
import 'package:treboard/widgets/extractor.dart';
import 'package:treboard/widgets/mdi.dart';
import 'package:treboard/widgets/toolbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treboard/widgets/nodes/note.dart';

class WhiteBoard extends ConsumerStatefulWidget {
  const WhiteBoard({super.key});

  @override
  ConsumerState<WhiteBoard> createState() => _WhiteBoardState();
}

class _WhiteBoardState extends ConsumerState<WhiteBoard> {
  final initScale = 0.1;
  double maxScale = 2;
  double offsetThreshold = 0.1;
  MouseCursor cursor = SystemMouseCursors.grab;

  Offset oldFocalPoint = Offset.zero;

  MDIManager mdiManager = MDIManager();

  late TransformationController _transformationController;

  // CustomNodes include Text, Expression, Image, etc.
  // Only Text is implemented for now
  // Text is a widget that can be dragound the board
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _transformationController =
        ref.watch(boardProvider).transformationController;
    return Scaffold(
      body: CallbackShortcuts(
        bindings: {
          const SingleActivator(
            LogicalKeyboardKey.keyZ,
            control: true,
          ): () => ref.read(boardProvider).undo(),
          const SingleActivator(
            LogicalKeyboardKey.keyY,
            control: true,
          ): () => ref.read(boardProvider).redo(),
          const SingleActivator(
            LogicalKeyboardKey.keyZ,
            shift: true,
            control: true,
          ): () => ref.read(boardProvider).redo(),
        },
        key: const ValueKey('shortcutHandler'),
        child: Focus(
          child: Stack(
            children: [
              InteractiveViewer(
                maxScale: maxScale,
                transformationController: _transformationController,
                onInteractionUpdate: (details) {
                  // apply transformation

                  oldFocalPoint = details.focalPoint;
                  maxScale += clampDouble(
                      details.scale - 1, -offsetThreshold, offsetThreshold);
                },
                child: GestureDetector(
                  onPanStart: (details) {},
                  onSecondaryTapDown: (details) {
                    // display context menu

                    showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                            details.globalPosition.dx,
                            details.globalPosition.dy,
                            details.globalPosition.dx + 1,
                            details.globalPosition.dy + 1),
                        items: const [
                          PopupMenuItem(
                            value: 1,
                            child: Text('Add Note'),
                          ),
                        ]).then((value) {
                      if (value == 1) {
                        // add a new CustomNode
                        // not ready yet
                        ref
                            .read(mdiProvider)
                            .addWindow(Note(), details.localPosition);
                      }
                    });
                  },
                  child: SizedBox(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: GridPaper(
                        color: Colors.grey.withOpacity(0.8),
                        divisions: 2,
                        interval: 1000,
                        child: BoardCanvas(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        )),
                  ),
                ),
              ),

              // display CustomNodes
              mdiManager,
              //...ref.watch(nodeProvider).nodes,
              Positioned(
                bottom: MediaQuery.of(context).size.height / 2 - (2 * 20 + 40),
                left: 20,
                child: const Toolbar(),
              ),

              const ColorBar(),

              Positioned(
                top: 20,
                left:
                    MediaQuery.of(context).size.width / 2 - (2 * 20 + 200) / 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Slider(
                        value: ref.watch(boardProvider).penWidth,
                        min: 2,
                        max: 20,
                        divisions: 4,
                        onChanged: (value) {
                          // change on exponential scale
                          ref.read(boardProvider.notifier).setPenWidth(value);
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      // some circular container to represent the size of the pen
                      Container(
                        margin: const EdgeInsets.all(10),
                        width: ref.watch(boardProvider).penWidth * 2,
                        height: ref.watch(boardProvider).penWidth * 2,
                        decoration: BoxDecoration(
                          color: ref.watch(boardProvider).penColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
