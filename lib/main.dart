import 'dart:async';
import 'package:final_project/signed_in_screen.dart';
import 'package:final_project/src/themedata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'src/firebase_options.dart';
import 'task_list.dart';
import 'dashboard.dart';
import 'task_model.dart';

///Name: Gerald Vinyeta
///Date: 12/14/2022
///Description: Handles tabbed navigation and autosave timer
///Bugs: N/A
///Reflection: Mostly boiler plate code, no obstacles or noteworthy functions
///            other than initState allowing for dynamic navigation
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
  final int? routeIndex;
  const TasksApp({super.key, this.routeIndex, required this.taskModel});

  @override
  State<TasksApp> createState() => _TasksAppState();
}

class _TasksAppState extends State<TasksApp> {
  int selectedIndex = 0;
  Timer? syncTimer;

  List<Widget> tabViews = [
    Consumer<TaskModel>(builder: (context, taskModel, child) {
      return TaskList(taskModel: taskModel);
    }),
    Consumer<TaskModel>(builder: (context, taskModel, child) {
      return Dashboard(taskModel: taskModel);
    }),
    Consumer<TaskModel>(builder: (context, taskModel, child) {
      return LoginScreen(taskModel: taskModel);
    }),
  ];

  //Initializes navigation and sync timer based on login state
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.routeIndex ?? 1;
    User? user = FirebaseAuth.instance.currentUser;
    //If user is logged in, change login page to signed in screen and start sync timer
    if (user != null) {
      tabViews[2] = Consumer<TaskModel>(builder: (context, taskModel, child) {
        return SignedInScreen(taskModel: taskModel);
      });
      //Autosave user data every 5 seconds
      syncTimer = Timer.periodic(const Duration(seconds: 5),
          (timer) => widget.taskModel.syncChanges());
    }
  }

  //Cancels autosave timer
  @override
  void dispose() {
    super.dispose();
    syncTimer?.cancel();
  }

  //Updates the tab selected by the user
  void _handleTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //3-tabbed app containing the task list, dashboard, and profile/login page.
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
                      label: 'Dashboard',
                      icon: Icon(Icons.data_thresholding_outlined)),
                  BottomNavigationBarItem(
                      label: 'Profile', icon: Icon(Icons.person)),
                ]),
            body: tabViews[selectedIndex]));
  }
}
