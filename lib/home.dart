import 'package:flutter/material.dart';
import 'task_model.dart';

class Home extends StatelessWidget {
  final TaskModel taskModel;
  const Home({required this.taskModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Home')),
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w800),
                          'Home')),
                  const Text(
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.w400),
                      'Welcome \nback!'), //When user is signed in, show username
                  Container(
                      padding: const EdgeInsets.only(top: 30),
                      child: const Text(
                          //These text fields will vary
                          textAlign: TextAlign.center,
                          'You have 4 tasks to complete this week')),
                  const Text(
                      textAlign: TextAlign.center,
                      'You have completed 85% of tasks on time.'),
                ])));
  }
}
