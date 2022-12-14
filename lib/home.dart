import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'task_model.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:carousel_slider/carousel_slider.dart';

/// Home is the "Dashboard" of the app. This is the first page that greets the users.
/// Author: Olivia Ozbaki, Gerald Vinyeta
/// Bugs: None that are apparent during testing
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
  String? completionRate;
  User? user = FirebaseAuth.instance.currentUser;
  String welcomeString = 'Welcome back';

  static List<Widget> carouselItems = [];

  // Get the correct grammatical form of "task(s)"
  String getTaskPlurality({required int numTasks}) {
    return (numTasks == 1) ? 'Task' : 'Tasks';
  }
  
  @override
  void initState() {
    super.initState();
    if (user != null) {
      welcomeString += ', ${user!.displayName}!';
    } else {
      welcomeString += '!';
    }
    
    // Get carousel variables
    remainingTasks = widget.taskModel.tasksDueThisWeek();
    completionRate = widget.taskModel.tasksOnTimePct();
    overdueTasks = widget.taskModel.tasksCurrOverdue();
    tasksCompleted = widget.taskModel.completedTasks();

    // Set carousel items
    carouselItems = [
      carouselItemContainer(
          context: context,
          header: '$remainingTasks',
          body: '${getTaskPlurality(numTasks: remainingTasks)} this week'),
      carouselItemContainer(
          context: context,
          header: '$tasksCompleted',
          body: '${getTaskPlurality(numTasks: tasksCompleted)} completed'),
      carouselItemContainer(
          context: context,
          header: '$overdueTasks',
          body: 'Overdue ${getTaskPlurality(numTasks: overdueTasks)}'),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: customClock(context),
                      )),
                      const SizedBox(height: 20),
                      Text(
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w600),
                          welcomeString),
                      Text(completionRate == null
                          ? 'Looks like you haven\'t completed any tasks yet.'
                          : 'You have completed $completionRate% of tasks on time.'),
                      const SizedBox(height: 20),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: CarouselSlider(
                              options: CarouselOptions(
                                scrollDirection: Axis.vertical,
                                viewportFraction: 0.3,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 5),
                                enlargeCenterPage: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                padEnds: true,
                              ),
                              items: carouselItems)),
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
            color: Colors.white.withOpacity(0.1),
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

/// Container decoration for carousel items
Widget carouselItemContainer(
    {required BuildContext context,
    required String header,
    required String body}) {
  return Container(
    height: 100,
    width: 100,
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white)),
    child: Stack(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
            style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
            header),
      ),
      Align(
          alignment: Alignment.centerRight,
          child: Text(textAlign: TextAlign.center, body))
    ]),
  );
}
