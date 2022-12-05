// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:final_project/task_item.dart';
import 'package:flutter/material.dart';
import 'task_model.dart';
import 'package:final_project/src/custom.dart';

enum SortOption { priority, name, date }

class TaskList extends StatefulWidget {
  final TaskModel taskModel;

  TaskList({required this.taskModel, Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  //Sorts tasks by given option
  void _sortBy(SortOption option) {
    setState(() {
      switch (option) {
        case (SortOption.priority):
          widget.taskModel.sortByPriority(context, widget.taskModel);
          break;
        case (SortOption.name):
          widget.taskModel.sortByName(context, widget.taskModel);
          break;
        case (SortOption.date):
          widget.taskModel.sortByDue(context, widget.taskModel);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //ListView of tasks
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Tasks')),
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.7),
                Theme.of(context).colorScheme.secondary.withOpacity(0.7),
              ]),
        )),
        actions: [
          //Popup menu that has sorting options
          PopupMenuButton<SortOption>(
              padding: EdgeInsets.only(right: 20),
              icon: Icon(Icons.menu),
              onSelected: (SortOption option) {
                _sortBy(option);
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<SortOption>>[
                    const PopupMenuItem<SortOption>(
                      value: SortOption.priority,
                      child: Text('Sort by priority'),
                    ),
                    const PopupMenuItem<SortOption>(
                      value: SortOption.name,
                      child: Text('Sort by name'),
                    ),
                    const PopupMenuItem<SortOption>(
                      value: SortOption.date,
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
              return currTask;
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
                    onPressed: (() => widget.taskModel.openTaskMenu(context,
                        taskModel: widget.taskModel, type: TaskMenu.add)),
                    child: Icon(Icons.add)),
              )),
        ),
      ]),
    );
  }
}
