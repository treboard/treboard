import 'package:flutter/material.dart';
import 'package:treboard/models/embeddable.dart';

class Note extends StatefulWidget with Embeddable {
  const Note({super.key});

  @override
  State<Note> createState() => _NoteState();

  @override
  String get name => "Note";
}

class _NoteState extends State<Note> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: double.infinity,
      child: const TextField(
          decoration: InputDecoration(border: InputBorder.none),
          textAlign: TextAlign.start,
          expands: true,
          maxLines: null,
          style: TextStyle(
            fontSize: 20,
          )),
    );
  }
}
