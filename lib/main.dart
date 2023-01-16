import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import "widgets/whiteboard.dart";
import "widgets/toolbar.dart";

void main() {
  runApp(AppContext());
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
      theme: ThemeData.light(),
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
