import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treboard/providers/board_provider.dart';

class PenColor {
  const PenColor(this.color);
  final Color color;
}

const List<PenColor> penColors = [
// set of 29 colors in rainbow order
  PenColor(Colors.black),
  PenColor(Colors.red),
  PenColor(Colors.orange),
  PenColor(Colors.yellow),
  PenColor(Colors.green),
  PenColor(Colors.blue),
  PenColor(Colors.indigo),
  PenColor(Colors.purple),
  PenColor(Colors.white),
];

@immutable
class ColorBar extends ConsumerStatefulWidget {
  const ColorBar({
    super.key,
  });

  @override
  _ColorBarState createState() => _ColorBarState();
}

class _ColorBarState extends ConsumerState<ColorBar> {
  void _changeColor(Color color) {
    ref.read(boardProvider.notifier).setPenColor(color);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30.0,
      left: MediaQuery.of(context).size.width / 2 -
          (penColors.length * 20.0) -
          (5 * penColors.length),
      // center horizontally

      child: Padding(
          padding: const EdgeInsets.only(
              top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              // Animated list of colors
              children: penColors
                  .map((color) => colorCircle(
                        color.color,
                        color.color == ref.watch(boardProvider).penColor,
                        onTap: () => _changeColor(color.color),
                      ))
                  .toList(),
            ),
          )),
    );
  }
}

Widget colorCircle(Color color, bool isSelected,
    {required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.all(5.0),
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: isSelected ? Colors.black : Colors.black.withOpacity(0.2),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
    ),
  );
}
