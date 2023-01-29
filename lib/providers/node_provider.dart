import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treboard/widgets/mdi.dart';

class MDI extends ChangeNotifier {
  var rng = Random();
  List<ResizableWindow> _windows = List.empty(growable: true);

  List<ResizableWindow> get windows => _windows;
  void updateWindowPosition(ResizableWindow window, Offset delta) {
    window.x += delta.dx;
    window.y += delta.dy;

    _windows.remove(window);
    _windows.add(window);

    notifyListeners();
  }

  void addWindow(Widget embed, Offset position) {
    ResizableWindow resizableWindow = ResizableWindow(embed: embed);

    //Set initial position

    resizableWindow.x = position.dx;
    resizableWindow.y = position.dy;

    //Add Window to List

    _windows.add(resizableWindow);
    notifyListeners();
  }

  void removeWindow(ResizableWindow widget) {
    _windows.remove(widget);
    notifyListeners();
  }
}

final mdiProvider = ChangeNotifierProvider((ref) => MDI());
