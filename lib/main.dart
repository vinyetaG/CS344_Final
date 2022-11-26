// ignore_for_file: unused_import

import 'package:final_project/src/themedata.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/firebase_options.dart';
import 'task_list.dart';
import 'home.dart';
import 'task_model.dart';
import 'Profile/profile_launch_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => TaskModel(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Time-Tips',
          home: Consumer<TaskModel>(builder: (context, taskModel, child) {
            return TasksApp(taskModel: taskModel);
          }),
          theme: appTheme)));
}

class TasksApp extends StatefulWidget {
  final TaskModel taskModel;
  const TasksApp({super.key, required this.taskModel});

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
      return ProfileLaunchScreen(taskModel: taskModel);
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
            body: tabViews[selectedIndex]));
  }
}
