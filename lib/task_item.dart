class TaskItem {
  String name;
  String? description;
  bool selected = false;
  
  TaskItem({required this.name, this.description});
}





























/*
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:flutter/cupertino.dart';

class Example extends StatelessWidget {
  int numDays = 0;
  int numHours = 0;
  int numMinutes = 0;
  int numSeconds = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: TimerCountdown(
          format: CountDownTimerFormat.daysHoursMinutesSeconds,
          endTime: DateTime.now().add(
            Duration(
              days: numDays,
              hours: numHours,
              minutes: numMinues,
              seconds: numSeconds,
            ),
          ),
          onEnd: () {
            print("Task Complete!");
          },
        ),
    );
  }
}*/
