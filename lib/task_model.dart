import 'package:flutter/material.dart';
import 'task_item.dart';

class TaskModel extends ChangeNotifier {
  final _taskList = <TaskItem>[];

  //Add task to task list
  void addTask(TaskItem item) {
    _taskList.add(item);
    notifyListeners();
  }

  //When a checkbox is selected/deselected, "toggle" appropriate task
  void toggleSelection({required int at, required bool state}) {
    _taskList[at].selected = state;
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
