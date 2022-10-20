// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'task_model.dart';

class Home extends StatelessWidget {
  final TaskModel taskModel;
  const Home({required this.taskModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text('Tab Two'),
    );
  }
}
