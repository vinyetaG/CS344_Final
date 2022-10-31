// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'task_model.dart';

class Home extends StatelessWidget {
  final TaskModel taskModel;
  const Home({required this.taskModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
                      'Home')),
              const Text(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.w400),
                  'Welcome \nback!'),
              Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: const Text(
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      'You have 4 tasks to complete this week')),
              const Text(
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  'You have completed 85% of tasks on time.'),
            ]));
  }
}
