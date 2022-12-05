import 'dart:async';
import 'package:final_project/src/themedata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/firebase_options.dart';
import 'task_list.dart';
import 'home.dart';
import 'task_model.dart';
import 'profile_launch_screen.dart';

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
  final int? index;
  const TasksApp({super.key, this.index, required this.taskModel});

  @override
  State<TasksApp> createState() => _TasksAppState();
}

class _TasksAppState extends State<TasksApp> {
  int selectedIndex = 0;
  late Timer syncTimer;

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

  @override
  void initState() {
    selectedIndex = widget.index ?? 0;
    if (widget.index == null) {
      //syncTimer = Timer.periodic(const Duration(seconds: 5),
      //    (timer) => widget.taskModel.syncChanges());
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {}
      super.initState();
      widget.taskModel.addTask(widget.taskModel,
          name: 'ZBC',
          description: 'Task description 1',
          priority: 0,
          dueDate: DateTime.now().add(const Duration(seconds: 3)));
      widget.taskModel.addTask(widget.taskModel,
          name: 'CBA',
          description: 'Task description 2',
          priority: 2,
          dueDate: DateTime.now().add(const Duration(seconds: 20)));
      widget.taskModel.addTask(widget.taskModel,
          name: 'MBE',
          description: 'Task description 3',
          priority: 1,
          dueDate: DateTime.now().add(const Duration(days: 2)));
    }

    // TaskItem(
    //     name: 'Zebra Task',
    //     description: 'Task description',
    //     priority: 2,
    //     dueDate: DateTime.now().add(const Duration(seconds: -10))),
    // TaskItem(
    //     name: 'Task 4',
    //     description: 'Task description',
    //     priority: 1,
    //     dueDate: DateTime.now().add(const Duration(seconds: 30))),
    // TaskItem(
    //     name: 'Alpha Task',
    //     description: 'Task description',
    //     priority: 0,
    //     dueDate: DateTime.now().add(const Duration(days: 6))),
    // TaskItem(
    //     name: 'Task 6',
    //     description: 'Task description',
    //     priority: 1,
    //     dueDate: DateTime.now().add(const Duration(days: 5))),
    // TaskItem(
    //     name: 'Task 7',
    //     description: 'Task description',
    //     priority: 2,
    //     dueDate: DateTime.now().add(const Duration(days: 1))),
    // TaskItem(
    //     name: 'Beta Task',
    //     description: 'Task description',
    //     priority: 1,
    //     dueDate: DateTime.now().add(const Duration(days: 12))),
    // TaskItem(
    //     name: 'Task 9',
    //     description: 'Task description',
    //     priority: 0,
    //     dueDate: DateTime.now().add(const Duration(days: 12))),
    // TaskItem(
    //     name: 'Task 10',
    //     description: 'Task description',
    //     priority: 1,
    //     dueDate: DateTime.now().add(const Duration(days: 11)))
  }

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
