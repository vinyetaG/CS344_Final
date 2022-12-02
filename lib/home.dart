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
  // TODO: Implement logic to display number of tasks completed
  // TODO: Implement logic to calculate completion rate
  double tasksCompleted = 0.0;
  int remainingTasks = 0;
  User? user = FirebaseAuth.instance.currentUser;
  String welcomeString = 'Welcome back';
  String taskPlurality = 'task';

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      welcomeString += ' , ${user!.displayName}!';
    } else {
      welcomeString += '!';
    }

    if (remainingTasks == 1 || remainingTasks == 0) {
      taskPlurality = 'tasks';
    }
    
    setState(() {
      _calculateTasks();
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Home')),
      ),
      body: Container(
          padding: const EdgeInsets.all(30),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            customClock(context),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w600),
                    welcomeString)),
            Align(
                key: null,
                alignment: Alignment.centerLeft,
                child: homeBoxesV1(
                    context: context,
                    header: 'Remaining Tasks',
                    body:
                        'You have $remainingTasks $taskPlurality to complete this week.')),
            const SizedBox(height: 20),
            Align(
                key: null,
                alignment: Alignment.centerRight,
                child: homeBoxesV2(
                    context: context,
                    header: 'Completion Rate',
                    body:
                        'You have completed $tasksCompleted% of tasks on time.')),
          ])),
    );
  }
  // Calculates # of remaining tasks and percentage of tasks completed on time
  void _calculateTasks() {
    remainingTasks = widget.taskModel.numTasks();
    tasksCompleted = widget.taskModel.tasksOnTime();
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

/// Box styling V1, used for remaining tasks
Widget homeBoxesV1(
    {required BuildContext context,
    required String header,
    required String body}) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.18,
    width: MediaQuery.of(context).size.width * 0.7,
    padding: const EdgeInsets.fromLTRB(30, 15, 30, 30),
    decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        border: Border.all(color: Colors.white)),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
              header),
          const SizedBox(height: 20),
          Text(textAlign: TextAlign.center, body)
        ]),
  );
}

/// Box styling V2, used for completion rate
Widget homeBoxesV2(
    {required BuildContext context,
    required String header,
    required String body}) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.18,
    width: MediaQuery.of(context).size.width * 0.7,
    padding: const EdgeInsets.fromLTRB(30, 15, 30, 30),
    decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
        border: Border.all(color: Colors.white)),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
              header),
          const SizedBox(height: 20),
          Text(textAlign: TextAlign.right, body)
        ]),
  );
}

