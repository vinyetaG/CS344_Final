// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:final_project/task_item.dart';
import 'package:flutter/material.dart';
import 'task_model.dart';

class TaskList extends StatelessWidget {
  final TaskModel taskModel;
  TaskList({required this.taskModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //ListView of tasks
    return Column(children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
          child: ListView.separated(
            itemCount: 5, // will be task list length
            itemBuilder: (BuildContext context, int index) {
              return TaskItem(name: "Task name", description: "filler");
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                thickness: 1,
              );
            },
          ),
        ),
      ),
      //Add task button
      const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 20, 20),
          child: Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                  onPressed: null, child: Icon(Icons.add)))),
    ]);
  }
}
