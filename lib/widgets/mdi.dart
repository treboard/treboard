import 'dart:math';

import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treboard/models/embeddable.dart';
import 'package:treboard/providers/node_provider.dart';

const List<Color> colors = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.pink,
  Colors.brown,
  Colors.teal,
  Colors.cyan,
  Colors.lime,
  Colors.indigo,
  Colors.amber,
  Colors.deepOrange,
  Colors.deepPurple,
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.grey,
];

class MDIManager extends ConsumerStatefulWidget {
  MDIManager({
    Key? key,
  }) : super(key: key);

  @override
  _MDIManagerState createState() => _MDIManagerState();
}

class _MDIManagerState extends ConsumerState<MDIManager> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: ref.watch(mdiProvider).windows.map((e) {
      return Positioned(
        left: e.x,
        top: e.y,
        key: e.key,
        child: e,
      );
    }).toList());
  }
}

class ResizableWindow extends ConsumerStatefulWidget {
  String? title;
  Widget? embed;
  final Color panelColor = colors[Random().nextInt(colors.length)];
  double currentHeight = 400.0, defaultHeight = 400.0;
  double currentWidth = 400.0, defaultWidth = 400.0;
  double x = 0.0;
  double y = 0.0;

  ResizableWindow({this.title, this.embed}) : super(key: UniqueKey());
  @override
  _ResizableWindowState createState() => _ResizableWindowState();
}

class _ResizableWindowState extends ConsumerState<ResizableWindow> {
  _getHeader() {
    return GestureDetector(
      onPanUpdate: (details) {
        ref
            .read(mdiProvider.notifier)
            .updateWindowPosition(widget, details.delta);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: widget.currentWidth,
        height: 40.0,
        color: widget.panelColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.title ?? "Untitled",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 16.0,
              ),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                  ref.read(mdiProvider.notifier).removeWindow(widget);
                },
                icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }

  _getBody() {
    return Container(
      width: widget.currentWidth,
      height: widget.currentHeight - 40.0,
      color: Colors.white,
      child: widget.embed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        //Here goes the same radius, u can put into a var or function
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            color: Color(0x54000000),
            spreadRadius: 4,
            blurRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: Stack(
          children: [
            Column(
              children: [_getHeader(), _getBody()],
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onHorizontalDragUpdate: _onHorizontalDragRight,
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeLeftRight,
                  opaque: true,
                  child: Container(
                    width: 4,
                  ),
                ),
              ),
            ),
            Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragRight,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeLeftRight,
                    opaque: true,
                    child: Container(
                      width: 4,
                    ),
                  ),
                )),
            // resizer for bottom right
            Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragLeft,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeLeftRight,
                    opaque: true,
                    child: Container(
                      width: 4,
                    ),
                  ),
                )),
            Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: GestureDetector(
                  onVerticalDragUpdate: _onHorizontalDragTop,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeUpDown,
                    opaque: true,
                    child: Container(
                      height: 4,
                    ),
                  ),
                )),
            Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onVerticalDragUpdate: _onHorizontalDragBottom,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeUpDown,
                    opaque: true,
                    child: Container(
                      height: 4,
                    ),
                  ),
                )),
            Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onPanUpdate: _onHorizontalDragBottomRight,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeUpLeftDownRight,
                    opaque: true,
                    child: Container(
                      height: 6,
                      width: 6,
                    ),
                  ),
                )),
            Positioned(
                bottom: 0,
                left: 0,
                child: GestureDetector(
                  onPanUpdate: _onHorizontalDragBottomLeft,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeUpRightDownLeft,
                    opaque: true,
                    child: Container(
                      height: 6,
                      width: 6,
                    ),
                  ),
                )),
            Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onPanUpdate: _onHorizontalDragTopRight,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeUpRightDownLeft,
                    opaque: true,
                    child: Container(
                      height: 6,
                      width: 6,
                    ),
                  ),
                )),
            Positioned(
                left: 0,
                top: 0,
                child: GestureDetector(
                  onPanUpdate: _onHorizontalDragTopLeft,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeUpLeftDownRight,
                    opaque: true,
                    child: Container(
                      height: 6,
                      width: 6,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _onHorizontalDragLeft(DragUpdateDetails details) {
    setState(() {
      widget.currentWidth -= details.delta.dx;
      if (widget.currentWidth < widget.defaultWidth) {
        widget.currentWidth = widget.defaultWidth;
      } else {
        ref
            .read(mdiProvider)
            .updateWindowPosition(widget, Offset(details.delta.dx, 0));
      }
    });
  }

  void _onHorizontalDragRight(DragUpdateDetails details) {
    setState(() {
      widget.currentWidth += details.delta.dx;
      if (widget.currentWidth < widget.defaultWidth) {
        widget.currentWidth = widget.defaultWidth;
      }
    });
  }

  void _onHorizontalDragBottom(DragUpdateDetails details) {
    setState(() {
      widget.currentHeight += details.delta.dy;
      if (widget.currentHeight < widget.defaultHeight) {
        widget.currentHeight = widget.defaultHeight;
      }
    });
  }

  void _onHorizontalDragTop(DragUpdateDetails details) {
    setState(() {
      widget.currentHeight -= details.delta.dy;
      if (widget.currentHeight < widget.defaultHeight) {
        widget.currentHeight = widget.defaultHeight;
      } else {
        ref
            .read(mdiProvider)
            .updateWindowPosition(widget, Offset(0, details.delta.dy));
      }
    });
  }

  void _onHorizontalDragBottomRight(DragUpdateDetails details) {
    _onHorizontalDragRight(details);
    _onHorizontalDragBottom(details);
  }

  void _onHorizontalDragBottomLeft(DragUpdateDetails details) {
    _onHorizontalDragLeft(details);
    _onHorizontalDragBottom(details);
  }

  void _onHorizontalDragTopRight(DragUpdateDetails details) {
    _onHorizontalDragRight(details);
    _onHorizontalDragTop(details);
  }

  void _onHorizontalDragTopLeft(DragUpdateDetails details) {
    _onHorizontalDragLeft(details);
    _onHorizontalDragTop(details);
  }
}
