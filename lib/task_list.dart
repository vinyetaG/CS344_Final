// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:final_project/task_item.dart';
import 'package:flutter/material.dart';
import 'task_model.dart';

enum TaskMenu { add, edit }

class TaskList extends StatefulWidget {
  final TaskModel taskModel;

  TaskList({required this.taskModel, Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final _formKey = GlobalKey<FormState>();

  //Priority levels used by dropdown menu
  List<DropdownMenuItem<int>> priorityLevels = [
    DropdownMenuItem(value: 0, child: Text("Low")),
    DropdownMenuItem(value: 1, child: Text("Medium")),
    DropdownMenuItem(value: 2, child: Text("High")),
  ];

  void _addTask(
      {required String name, String? description, required int priority}) {
    widget.taskModel.addTask(TaskItem(
      name: name,
      description: description,
      priority: priority,
    ));
    Navigator.of(context).pop();
  }

  ///Opens pop up menu to either add or edit a task
  Future<void> _openTaskMenu({required TaskMenu type}) async {
    String header;
    String actionLabel;
    String? newTaskName;
    String? newTaskDescription;
    int? newPriorityLevel;

    ///Determines fields that are shown depending on if user is in add or edit
    ///task menu
    if (type == TaskMenu.add) {
      header = 'Create New Task';
      actionLabel = 'Create Task';
    } else {
      header = 'Edit Task';
      actionLabel = 'Save Changes';
    }
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            insetPadding: EdgeInsets.all(0),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12, 24, 24, 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: (() => Navigator.of(context).pop()),
                              icon: Icon(Icons.arrow_back_ios_new)),
                          Text(
                            header,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          //Delete task button is shown if in the edit menu
                          if (type == TaskMenu.edit)
                            Material(
                              color: Theme.of(context).colorScheme.secondary,
                              child: IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.highlight_remove_outlined)),
                            ),
                        ],
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Task name',
                                ),
                                validator: (text) => text!.isEmpty
                                    ? 'You must give the task a name.'
                                    : null,
                                onChanged: (text) => newTaskName = text,
                              ),
                              SizedBox(height: 15), //whitespace
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Task description (optional)',
                                ),
                                validator: (text) => text!.length > 50
                                    ? 'Description can be at most 50 characters long.'
                                    : null,
                                onChanged: (text) => newTaskDescription = text,
                              ),
                              SizedBox(height: 15), //whitespace
                              DropdownButtonFormField<int>(
                                hint: Text('Priority level'),
                                items: priorityLevels,
                                validator: (value) => value == null
                                    ? 'Please set a valid priority level for this task.'
                                    : null,
                                //value: priorityLevels.first.value,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    newPriorityLevel = newValue!;
                                  });
                                },
                              ),
                              SizedBox(height: 30), //whitespace
                            ],
                          )),
                      Container(
                          color: Theme.of(context).colorScheme.primary,
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.10,
                          child: ElevatedButton(
                              onPressed: ((() {
                                if (_formKey.currentState!.validate()) {
                                  _addTask(
                                      name: newTaskName!,
                                      description: newTaskDescription,
                                      priority: newPriorityLevel!);
                                }
                              })),
                              child: Text(actionLabel)))
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //ListView of tasks
    return Column(children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
          child: ListView.separated(
            itemCount: widget.taskModel.numTasks(),
            itemBuilder: (BuildContext context, int index) {
              return widget.taskModel.getTask(index);
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(thickness: 1, color: Colors.grey[800]);
            },
          ),
        ),
      ),
      //Add task button
      Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 20, 20),
          child: Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                  onPressed: (() => _openTaskMenu(type: TaskMenu.add)),
                  child: Icon(Icons.add)))),
    ]);
  }
}
