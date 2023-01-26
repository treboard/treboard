import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuBar extends ConsumerStatefulWidget {
  const MenuBar({super.key});

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends ConsumerState<MenuBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: Colors.grey[300],
      child: Row(
        children: [
          const Text('File'),
          const Text('Edit'),
          const Text('View'),
          const Text('Help'),
        ],
      ),
    );
  }
}
