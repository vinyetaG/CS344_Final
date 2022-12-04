import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'task_model.dart';
import 'package:analog_clock/analog_clock.dart';

class Home extends StatefulWidget {
  final TaskModel taskModel;
  const Home({required this.taskModel, Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int tasksCompleted = 0;
  int remainingTasks = 0;
  int overdueTasks = 0;
  double completionRate = 0.0;
  User? user = FirebaseAuth.instance.currentUser;
  String welcomeString = 'Welcome back';

  // Get the correct grammatical form of "task(s)"
  String getTaskPlurality({required int numTasks}) {
    return (numTasks == 1) ? 'Task' : 'Tasks';
  }

  // Calculates # of remaining tasks and percentage of tasks completed on time
  void _updateTaskStats() {
    setState(() {
      remainingTasks = widget.taskModel.numTasks();
      tasksCompleted = widget.taskModel.numCompletedTasks();
      completionRate = widget.taskModel.tasksOnTime();
      overdueTasks = widget.taskModel.numOverdueTasks();
    });
    
  @override
  void initState() {
    if (user != null) {
      welcomeString += ', ${user!.displayName}!';
    } else {
      welcomeString += '!';
    }
    _updateTaskStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    // Task stats on rotation
    List<Widget> carouselItems = [
      carouselItemContainer(
          context: context,
          header: '$remainingTasks',
          body: 'Remaining ${getTaskPlurality(numTasks: remainingTasks)}'),
      carouselItemContainer(
          context: context,
          header: '$tasksCompleted',
          body: '${getTaskPlurality(numTasks: tasksCompleted)} Completed'),
      carouselItemContainer(
          context: context,
          header: '$overdueTasks',
          body: 'Overdue ${getTaskPlurality(numTasks: overdueTasks)}'),
    ];
    
    
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Home')),
        flexibleSpace: Container(
              decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                ]),
          )),
      ),
      body: Center(
            child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /*customClock(context),*/
                      Text(
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w600),
                          welcomeString),
                      const SizedBox(height: 20),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: CarouselSlider(
                              options: CarouselOptions(
                                viewportFraction: 0.5,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 2),
                                enlargeCenterPage: true,
                                clipBehavior: Clip.none,
                                padEnds: true,
                              ),
                              items: carouselItems)),
                      const SizedBox(height: 20),
                      Text(
                          'This week you have completed $completionRate% of tasks on time.'),
                    ]))));
  }
}

/// Live analog clock used for decoration
Widget customClock(BuildContext context) {
  return SizedBox(
      height: 150,
      width: 150,
      child: AnalogClock(
        decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.white),
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
            shape: BoxShape.circle),
        width: 100,
        isLive: true,
        hourHandColor: Colors.white,
        minuteHandColor: Colors.white,
        showSecondHand: true,
        numberColor: Colors.white,
        showNumbers: true,
        showAllNumbers: false,
        textScaleFactor: 1.4,
        showTicks: true,
        showDigitalClock: false,
        datetime: DateTime.now(),
      ));
}

Widget carouselItemContainer(
    {required BuildContext context,
    required String header,
    required String body}) {
  return Container(
    height: 200,
    width: 200,
    padding: const EdgeInsets.all(30),
    decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white)),
    child: Stack(children: [
      Align(
        alignment: Alignment.topCenter,
        child: Text(
            style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
            header),
      ),
      Align(
          alignment: Alignment.bottomCenter,
          child: Text(textAlign: TextAlign.center, body))
    ]),
  );
}


