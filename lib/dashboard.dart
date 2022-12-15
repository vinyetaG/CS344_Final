import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'task_model.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:carousel_slider/carousel_slider.dart';

///Name: Olivia Ozbaki, Gerald Vinyeta
///Date: 12/14/2022
///Description: Dashboard where the user is greeted and stats regarding their
///             productivity and tasks are shown.
///Bugs: N/A
///Reflection: We went through many iterations of styles and we weren't able to
///            implement the stats until later, but no major issues
class Dashboard extends StatefulWidget {
  final TaskModel taskModel;
  const Dashboard({required this.taskModel, Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int tasksCompleted = 0;
  int remainingTasks = 0;
  int overdueTasks = 0;
  String? completionRate;
  User? user = FirebaseAuth.instance.currentUser;
  String welcomeString = 'Welcome';
  late String completionRateStr;

  static List<Widget> carouselItems = [];

  //Get the correct grammatical form of "task(s)"
  String _getTaskPlurality({required int numTasks}) {
    return (numTasks == 1) ? 'Task' : 'Tasks';
  }

  //Fetch info to display on carousel, as well as the string welcoming the user
  @override
  void initState() {
    super.initState();

    remainingTasks = widget.taskModel.tasksDueThisWeek();
    completionRate = widget.taskModel.tasksOnTimePct();
    overdueTasks = widget.taskModel.tasksCurrOverdue();
    tasksCompleted = widget.taskModel.completedTasks();

    if (completionRate != null) {
      completionRateStr =
          'You have completed $completionRate% of tasks on time.';
    } else {
      completionRateStr = 'Looks like you haven\'t completed any tasks yet.';
    }

    if (user != null) {
      welcomeString += ', ${user!.displayName}!';
    } else {
      welcomeString += '!';
      completionRateStr += '\nRegister now to sync data across sessions.';
    }
    String taskPlurality = _getTaskPlurality(numTasks: remainingTasks);

    //Task stats on rotation
    carouselItems = [
      carouselItemContainer(
          context: context,
          header: '$remainingTasks',
          body: '$taskPlurality this week'),
      carouselItemContainer(
          context: context,
          header: '$tasksCompleted',
          body: '$taskPlurality completed'),
      carouselItemContainer(
          context: context,
          header: '$overdueTasks',
          body: 'Overdue $taskPlurality'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Dashboard')),
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
                          //welcome string
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w600),
                          welcomeString),
                      Text(
                        //completion rate
                        completionRateStr,
                        textAlign: TextAlign.center,
                      ),
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

//Formats display for each carousel item
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
