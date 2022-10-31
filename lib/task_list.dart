// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

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
              return ListTile(
                tileColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                    //rounded edge list tile
                    borderRadius: BorderRadius.circular(20)),
                title: Text(
                  'task name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('description'),
                leading: Checkbox(
                    //When pressed "toggles" that task item
                    value: false,
                    onChanged: ((value) =>
                        taskModel.toggleSelection(at: index, state: value!))),
                trailing: Text('(timer)'),
              );
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
