// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TaskItem extends StatefulWidget {
  String name;
  String? description;
  bool selected = false;
  int priority = 0;

  TaskItem({super.key, required this.name, this.description});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey[300],
      shape: RoundedRectangleBorder(
          //rounded edge list tile
          borderRadius: BorderRadius.circular(20)),
      title: Text(
        widget.name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(widget.description ?? ""),
      leading: Checkbox(
          //When pressed "toggles" this task item
          value: widget.selected,
          onChanged: (bool? value) {
            setState(() {
              widget.selected = value!;
            });
          }),
      trailing: Text('(timer)'),
    );
  }
}
