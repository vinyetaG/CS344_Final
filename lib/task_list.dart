// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:final_project/task_item.dart';
import 'package:flutter/material.dart';
import 'task_model.dart';
import 'package:final_project/src/custom_widgets.dart';

class TaskList extends StatefulWidget {
  final TaskModel taskModel;

  TaskList({required this.taskModel, Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  editTask(TaskItem taskItem) {
    widget.taskModel.openTaskMenu(context, type: TaskMenu.edit);
  }

  @override
  Widget build(BuildContext context) {
    //ListView of tasks
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('To-Do List')),
        actions: [
          //Popup menu that has sorting options
          PopupMenuButton<String>(
              padding: EdgeInsets.only(right: 20),
              icon: Icon(Icons.menu),
              onSelected: (String sortOption) {
                setState(() {
                  switch (sortOption) {
                    case ('priority'):
                      widget.taskModel.sortByPriority();
                      break;
                    case ('name'):
                      widget.taskModel.sortByName();
                      break;
                    case ('date'):
                      widget.taskModel.sortByDue();
                      break;
                  }
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'priority',
                      child: Text('Sort by priority'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'name',
                      child: Text('Sort by name'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'date',
                      child: Text('Sort by due date'),
                    ),
                  ]),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width * 0.04,
            ),
            itemCount: widget.taskModel.numTasks(),
            itemBuilder: (BuildContext context, int index) {
              TaskItem currTask = widget.taskModel.getTask(index);
              //List tile containing info for each task
              return ListTile(
                  onTap: (() => //Show full info on task
                      widget.taskModel
                          .openInfoPanel(context, taskItem: currTask)),
                  //If task is overdue, red. Else darker green depending on priority
                  tileColor: currTask.isOverdue
                      ? TaskItem.tileColors[3]
                      : TaskItem.tileColors[currTask.priority],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text(
                    currTask.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    currTask.description ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Checkbox(
                      //If user checks off the item, prompt completion
                      value: currTask.selected,
                      onChanged: (bool? value) {
                        setState(() {
                          currTask.selected = true;
                        });
                        widget.taskModel
                            .confirmCompletion(context, taskItem: currTask);
                      }),
                  trailing: currTask.timer);
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                  thickness: 1,
                  color: Theme.of(context).scaffoldBackgroundColor);
            },
          ),
        ),

        ///Provides positioning for floating add button and prevents it from
        ///obfuscating list tile info
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: MediaQuery.of(context).size.width,
          child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    0,
                    MediaQuery.of(context).size.height * 0.045,
                    MediaQuery.of(context).size.width * 0.04,
                    MediaQuery.of(context).size.height * 0.03),
                child: FloatingActionButton(
                    onPressed: (() => widget.taskModel
                        .openTaskMenu(context, type: TaskMenu.add)),
                    child: Icon(Icons.add)),
              )),
        ),
      ]),
    );
  }
}
