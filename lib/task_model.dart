import 'package:flutter/material.dart';
import 'task_item.dart';

class TaskModel extends ChangeNotifier {
  final _taskList = <TaskItem>[
    TaskItem(name: 'Task 1', description: 'Task description', priority: 0),
    TaskItem(name: 'Task 2', description: 'Task description', priority: 1),
    TaskItem(name: 'Task 3', description: 'Task description', priority: 2),
    TaskItem(name: 'Task 4', description: 'Task description', priority: 1),
    TaskItem(name: 'Task 5', description: 'Task description', priority: 0),
  ];
  OverlayEntry? popUpMenu;

  //Remove overlay menu
  void removePopUp() {
    popUpMenu?.remove();
    popUpMenu = null;
  }

  //Add task to task list
  void addTask(TaskItem item) {
    _taskList.add(item);
    notifyListeners();
  }

  TaskItem getTask(int index) {
    return _taskList[index];
  }

  //Returns the number of tasks in the task list
  int numTasks() {
    return _taskList.length;
  }

  //Removes the given task
  void removeTask(int index) {
    _taskList.removeAt(index);
    notifyListeners();
  }
}
