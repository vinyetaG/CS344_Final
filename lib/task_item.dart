import 'package:final_project/src/themedata.dart';
import 'package:flutter/material.dart';

class TaskItem {
  String name;
  String? description;
  bool selected = false;
  int priority;
  DateTime? dueDate;
  bool isOverdue = false;

  static List<Color?> tileColors = [
    //Correlate to priority
    Colors.grey[300],
    appTheme.colorScheme.secondary,
    appTheme.colorScheme.primary,
    Colors.red[400] //Overdue
  ];

  TaskItem({
    required this.name,
    this.dueDate,
    this.description,
    required this.priority,
  });
}
