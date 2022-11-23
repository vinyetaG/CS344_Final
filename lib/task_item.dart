import 'package:final_project/src/custom_widgets.dart';
import 'package:final_project/src/themedata.dart';
import 'package:flutter/material.dart';

class TaskItem {
  String name;
  String? description;
  bool selected = false;
  int priority;
  DateTime? dueDate;
  bool isOverdue = false;
  TaskTimer timer = const TaskTimer();

  static List<Color?> tileColors = [
    //Correlate to priority
    Colors.grey[300],
    appTheme.colorScheme.secondary,
    appTheme.colorScheme.primary,
    Colors.red[300] //Overdue
  ];

  TaskItem({
    required this.name,
    this.dueDate,
    this.description,
    required this.priority,
  });
}
