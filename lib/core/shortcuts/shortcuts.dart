import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

final undoKeySet =
    LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyZ);
final redoKeySet = LogicalKeySet(LogicalKeyboardKey.control,
    LogicalKeyboardKey.shift, LogicalKeyboardKey.keyZ);

class UndoIntent extends Intent {}

class RedoIntent extends Intent {}

class ShortcutHandler extends StatefulWidget {
  const ShortcutHandler({
    Key? key,
    required this.child,
    required this.undo,
    required this.redo,
  }) : super(key: key);

  final Widget child;
  final VoidCallback undo;
  final VoidCallback redo;

  @override
  State<ShortcutHandler> createState() => _ShortcutHandlerState();
}

class _ShortcutHandlerState extends State<ShortcutHandler> {
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        undoKeySet: UndoIntent(),
        redoKeySet: RedoIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          UndoIntent: CallbackAction<UndoIntent>(
            onInvoke: (UndoIntent intent) => widget.undo(),
          ),
          RedoIntent: CallbackAction<RedoIntent>(
            onInvoke: (RedoIntent intent) => widget.redo(),
          ),
        },
        child: widget.child,
      ),
    );
  }
}
