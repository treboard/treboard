import 'package:flutter/material.dart';
import 'package:gehenna/providers/node_provider.dart';

// TODO: implement note
// An expression is a widget that displays a textbox containing a note
// for now, data is not persistent

class Note extends StatefulWidget {
  Note({
    super.key,
  });

  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
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
        child: const TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            border: InputBorder.none,
            hintText: 'New Note',
          ),
        ),
      ),
    );
  }
}
