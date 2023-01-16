import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import "widgets/whiteboard.dart";
import "widgets/toolbar.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:gehenna/providers/board.dart';

void main() {
  runApp(
    const ProviderScope(
      child: AppContext(),
    ),
  );
}

class AppContext extends StatefulWidget {
  const AppContext({super.key});

  @override
  State<AppContext> createState() => _AppContextState();
}

class _AppContextState extends State<AppContext> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gehenna',
      theme: ThemeData(),
      home: Scaffold(
        body: Column(
          children: const [
            Expanded(
              child: WhiteBoard(),
            ),
          ],
        ),
      ),
    );
  }
}