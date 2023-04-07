import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import "widgets/whiteboard.dart";
import "widgets/toolbar.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:treboard/providers/board_provider.dart';

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
      title: 'TreBoard',
      theme: ThemeData(
        useMaterial3: true,
        splashColor: Colors.transparent,
        highlightColor: Colors.orangeAccent,
        hoverColor: Colors.transparent,
      ),
      home: const WhiteBoard(),
    );
  }
}
