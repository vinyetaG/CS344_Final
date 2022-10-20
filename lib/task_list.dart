// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'task_model.dart';

class TaskList extends StatelessWidget {
  final TaskModel taskModel;
  TaskList({required this.taskModel, Key? key}) : super(key: key);

  var taskItems = [];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //Expanded needed to limit ListView size
      Expanded(
        child: ListView.separated(
          itemCount: 5, // change this when model method is done
          itemBuilder: (BuildContext context, int index) {
            return const ListTile(
              title: Text('task name'),
              subtitle: Text('description'),
              leading: Text('checkbox'),
              trailing: Text('timer'),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              // i removed color, replace if needed
              thickness: 1,
            );
          },
        ),
      ),
      const FloatingActionButton(onPressed: null, child: Icon(Icons.add)),
    ]);
  }
}
