import 'package:flutter/material.dart';
import 'task_item.dart';

class TaskModel extends ChangeNotifier {
  final _taskList = <TaskItem>[];

  void addTask(TaskItem item) {
    _taskList.add(item);
    notifyListeners();
  }

  void toggleSelection({required int at, required bool state}) {
    _taskList[at].selected = state;
  }

  int numTasks() {
    return _taskList.length;
  }

  void removeTask(int index) {
    _taskList.removeAt(index);
    notifyListeners();
  }
}
