import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treboard/providers/node_provider.dart';

List<Color> colors = [
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

class CustomNode extends ConsumerStatefulWidget {
  CustomNode({super.key, required this.child, required this.position});

  Widget child;
  Offset position;
  Color color = colors[Random().nextInt(colors.length)];

  @override
  _CustomNodeState createState() => _CustomNodeState();
}

class _CustomNodeState extends ConsumerState<CustomNode> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: Column(children: [
        // some panel that we can drag around
        Container(
          margin: const EdgeInsets.only(
            bottom: 5,
          ),
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          height: 40,
          width: 200,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                widget.position += details.delta;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('Untitled ', textAlign: TextAlign.center),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    // delete this node
                    ref.read(nodeProvider.notifier).removeNode(widget);
                  },
                  icon: Icon(Icons.delete),
                ),
                const Icon(Icons.drag_handle),
              ],
            ),
          ),
        ),
        Container(
          width: 200.0,
          height: 200.0,
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
          child: widget.child,
        ),
      ]),
    );
  }
}
