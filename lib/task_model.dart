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
  
  //Sorts by priority
  void sortByPriority() {
    _taskList.sort((a, b) => b.priority.compareTo(a.priority));
    notifyListeners();
  }

  //Sorts by due date
  void sortByDue() {
    //_taskList.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    notifyListeners();
  }

  //Sorts by most recently added
  void sortByName() {
    _taskList.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }
}
