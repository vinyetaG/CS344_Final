// ignore_for_file: prefer_const_constructors

import 'package:final_project/src/themedata.dart';
import 'package:flutter/material.dart';
import 'task_model.dart';

// ignore: must_be_immutable
class TaskItem extends StatefulWidget {
  String name;
  String? description;
  bool selected = false;
  int priority;
  DateTime? dueDate;
  bool isOverdue = false;

  static List<Color?> tileColors = [
    Colors.grey[300],
    appTheme.colorScheme.secondary,
    appTheme.colorScheme.primary
  ];

  TaskItem(
      {super.key,
      required this.name,
      this.dueDate,
      this.description,
      this.priority = 0});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: null,
      tileColor: TaskItem.tileColors[widget.priority],
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
          onChanged: (bool? value) async {
            setState(() {
              widget.selected = value!;
            });
          }),
      onLongPress: () async {
        bool? delete = await showDeleteConfirmDialog1();
        if (delete == null) {
        } else {
          print("confirm");
          //... 删除文件
        }
      },
      trailing: Text('timer'),
    );
  }

  Future<bool?> showDeleteConfirmDialog1() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("hint"),
          content: Text("Confirm you delete the item"),
          actions: <Widget>[
            TextButton(
              child: Text("cancel"),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            TextButton(
              child: Text('delete'),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
