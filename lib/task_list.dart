// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'task_model.dart';

class TaskList extends StatelessWidget {
  final TaskModel taskModel;
  TaskList({required this.taskModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView.separated(
          itemCount: 5, // change this when model method is done
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('task name'),
              subtitle: Text('description'),
              leading: Checkbox(
                  value: false,
                  onChanged: ((value) =>
                      taskModel.toggleSelection(at: index, state: value!))),
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
      const Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(onPressed: null, child: Icon(Icons.add)),
      ),
    ]);
  }
}
