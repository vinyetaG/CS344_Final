// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_list.dart';
import 'profile.dart';
import 'home.dart';
import 'task_model.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => TaskModel(),
      child: MaterialApp(
        title: 'Time Tracker',
        home: const TasksApp(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromARGB(255, 93, 135, 95),
            secondary: const Color.fromARGB(255, 159, 191, 160),
          ),
        ),
      )));
}

class TasksApp extends StatefulWidget {
  const TasksApp({super.key});

  @override
  State<TasksApp> createState() => _TasksAppState();
}

class _TasksAppState extends State<TasksApp> {
  int selectedIndex = 0;
  List<Widget> tabViews = [
    Consumer<TaskModel>(builder: (context, taskModel, child) {
      return TaskList(taskModel: taskModel);
    }),
    Consumer<TaskModel>(builder: (context, taskModel, child) {
      return Home(taskModel: taskModel);
    }),
    Consumer<TaskModel>(builder: (context, taskModel, child) {
      return Profile(taskModel: taskModel);
    }),
  ];

  void _handleTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: Colors.grey[800],
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: selectedIndex,
                showUnselectedLabels: true,
                onTap: _handleTap,
                items: const [
                  BottomNavigationBarItem(
                      label: 'Tasks', icon: Icon(Icons.timer)),
                  BottomNavigationBarItem(
                      label: 'Home', icon: Icon(Icons.home)),
                  BottomNavigationBarItem(
                      label: 'Profile', icon: Icon(Icons.person)),
                ]),
            appBar: AppBar(
              title: const Center(child: Text('Time Tracker')),
            ),
            body: tabViews[selectedIndex]));
  }
}
