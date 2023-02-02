import 'package:flutter/material.dart';
import 'package:treboard/models/embeddable.dart';

class Note extends StatefulWidget with Embeddable {
  String? content;
  Note({super.key, this.content = ""});

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
