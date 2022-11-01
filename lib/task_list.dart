// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'task_model.dart';

class TaskList extends StatefulWidget {
  final TaskModel taskModel;
  TaskList({required this.taskModel, Key? key}) : super(key: key);

  @override
  TaskListState createState() {
    return TaskListState();
  }
}

class TaskListState extends State<TaskList> {
  final items = List<String>.generate(5, (i) => 'Task ${i + 1}');
  final descriptions = List<String>.generate(5, (i) => 'Description ${i + 1}');
  late final TaskModel taskModel;
  @override
  Widget build(BuildContext context) {
    //ListView of tasks
    return Column(children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
          child: ListView.separated(
            itemCount: items.length, // will be task list length
            itemBuilder: (BuildContext context, int index) {
              final description = descriptions[index];
              final item = items[index];
              return Dismissible(
                  // Each Dismissible must contain a Key. Keys allow Flutter to
                  // uniquely identify widgets.
                  key: Key(item),
                  onDismissed: (direction) {
                    // Provide a function that tells the app
                    // what to do after an item has been swiped away.
                    setState(() {
                      items.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$item dismissed')));
                  },
                  //delete the task with the red box
                  background: Container(
                    color: Colors.red,
                  ),
                  child: ListTile(
                    tileColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                        //rounded edge list tile
                        borderRadius: BorderRadius.circular(20)),
                    title: Text(
                      item,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(description),
                    leading: Checkbox(
                        //When pressed "toggles" that task item
                        value: false,
                        onChanged: ((value) => taskModel.toggleSelection(
                            at: index, state: value!))),
                    trailing: Text('(timer)'),
                  ));
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                thickness: 1,
              );
            },
          ),
        ),
      ),
      const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 20, 20),
          child: Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                  onPressed: null, child: Icon(Icons.add)))),
    ]);

    //Add task button
  }
}
