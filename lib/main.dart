// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_list.dart';
import 'profile_signed_in.dart';
import 'home.dart';
import 'task_model.dart';
import 'profile_signed_out.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => TaskModel(),
      child: MaterialApp(
        title: 'Time-Tips',
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
    //Change these later to accomodate signed in route
    Consumer<TaskModel>(builder: (context, taskModel, child) {
      return TaskList(taskModel: taskModel);
    }),
    Consumer<TaskModel>(builder: (context, taskModel, child) {
      return Home(taskModel: taskModel);
    }),
    Consumer<TaskModel>(builder: (context, taskModel, child) {
      return ProfileSignedOut(taskModel: taskModel);
    }),
  ];

  void _handleTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //3-tabbed app with gray background
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
              title: const Center(child: Text('Time-Tips')),
            ),
            body: tabViews[selectedIndex]));
  }
}
