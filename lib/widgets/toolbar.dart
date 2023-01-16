// create a floating toolbar

import 'package:flutter/material.dart';

class Toolbar extends StatefulWidget {
  const Toolbar({super.key});

  @override
  State<Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.draw_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.format_shapes_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.undo_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.redo_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.cleaning_services_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
