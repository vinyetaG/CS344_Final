import 'package:flutter/material.dart';
import 'task_item.dart';

class TaskModel extends ChangeNotifier {
  final taskList = [];

  void addTask(TaskItem item) {
    taskList.add(item);
  }

  int numTasks() {
    return taskList.length;
  }

  void deleteTask(int index) {
    taskList.removeAt(index);
  }
}
