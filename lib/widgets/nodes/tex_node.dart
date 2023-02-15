import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class TexNode extends StatelessWidget {
  const TexNode({Key? key, required this.tex}) : super(key: key);
  final String tex;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: Math.tex(
        textScaleFactor: 5,
        tex,
      ),
    );
  }
}
