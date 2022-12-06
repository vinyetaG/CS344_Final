import 'dart:async';
import 'package:final_project/src/themedata.dart';
import 'package:flutter/material.dart';
import 'task_model.dart';

// ignore: must_be_immutable
class TaskItem extends StatefulWidget {
  final TaskModel taskModel;
  String name;
  String? description;
  int priority;
  DateTime dueDate;
  int? timerStarted;
  bool timerRunning;
  int secondsElapsed;

  static List<Color?> tileColors = [
    //Correlate to priority
    Colors.grey[300],
    appTheme.colorScheme.secondary,
    appTheme.colorScheme.primary,
    Colors.red[300] //Reserved for overdue tasks
  ];

  TaskItem(this.taskModel,
      {super.key,
      required this.name,
      required this.dueDate,
      this.description,
      required this.priority,
      this.timerRunning = false,
      this.secondsElapsed = 0,
      this.timerStarted}) {
    if (priority > 3 || priority < 0) {
      throw ArgumentError(
          "Priority must be an integer between 0 and 2, or 3 if the task is to be considered overdue.");
    }
  }

  void resetTimer() {
    timerRunning = false;
    secondsElapsed = 0;
    timerStarted = null;
  }

  @override
  State<TaskItem> createState() => TaskItemState();
}

class TaskItemState extends State<TaskItem> {
  bool selected = false;
  String? timerText;

  Timer? overdueCheckTimer;
  Timer? timerIncrement;

  //Initialize timers and timer display
  @override
  void initState() {
    super.initState();
    //If not already overdue, check for overdue task when it shows up in the task list
    //then every 5 seconds
    if (widget.priority != 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverdue());
      overdueCheckTimer = Timer.periodic(
          const Duration(seconds: 5), (timer) => _checkOverdue());
    }
    //If task item's timer was running, keep counting time elapsed
    if (!widget.timerRunning) {
      _secondsToTimer(widget.secondsElapsed);
    } else {
      _secondsToTimer(
          (DateTime.now().millisecondsSinceEpoch - widget.timerStarted!) ~/
              1000);
      //Update seconds elapsed to account for time elapsed since timer was canceled
      widget.secondsElapsed +=
          (DateTime.now().millisecondsSinceEpoch - widget.timerStarted!) ~/
                  1000 -
              widget.secondsElapsed;
      //Restart timer for timer display
      timerIncrement = Timer.periodic(
          const Duration(seconds: 1), (timer) => _incrementTimer());
    }
  }

  //Marks tasks as overdue if it is past the due date and returns whether it is overdue
  bool _checkOverdue() {
    if (DateTime.now().compareTo(widget.dueDate) > 0) {
      setState(() {
        widget.priority = 3;
      });
      overdueCheckTimer?.cancel();
      return true;
    }
    return false;
  }

  //Dispose of timers
  @override
  void dispose() {
    super.dispose();
    overdueCheckTimer?.cancel();
    timerIncrement?.cancel();
  }

  //Increments the task's timer and updates the time shown
  void _incrementTimer() {
    if (widget.timerRunning) {
      widget.secondsElapsed++;
      _secondsToTimer(
          (DateTime.now().millisecondsSinceEpoch - widget.timerStarted!) ~/
              1000);
    }
  }

  //Toggles between starting and stopping the task's timer.
  void _toggleTimer() {
    if (widget.timerRunning) {
      timerIncrement!.cancel();
      widget.timerRunning = false;
    } else {
      timerIncrement = Timer.periodic(
          const Duration(seconds: 1), (timer) => _incrementTimer());
      widget.timerStarted =
          DateTime.now().millisecondsSinceEpoch - widget.secondsElapsed * 1000;
      widget.timerRunning = true;
    }
  }

  //Formats the number of seconds elapsed into H:MM:SS format
  void _secondsToTimer(int secondsElapsed) {
    int hours = secondsElapsed ~/ 3600;
    int minutes = (secondsElapsed - (hours * 3600)) ~/ 60;
    int seconds = (secondsElapsed - (hours * 3600) - (minutes * 60));

    timerText =
        '${hours.toString()}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: (() async {
          //Show full info on task
          int startPriority = widget.priority;
          bool edited =
              await widget.taskModel.openInfoPanel(context, taskItem: widget);
          //Rebuild to show new fields if edited
          if (edited) {
            if (startPriority == 3) {
              bool overdue = _checkOverdue();
              //if overdue task was assigned to new date, reinstate overdue
              //check timer.
              if (!overdue) {
                overdueCheckTimer = Timer.periodic(
                    const Duration(seconds: 5), (timer) => _checkOverdue());
              }
            }
            //If timer was reset, update timer text
            if (widget.secondsElapsed == 0 && widget.timerRunning == false) {
              timerText = '0:00:00';
            }
            setState(() {});
          }
        }),
        //If task is overdue, red. Else darker green depending on priority
        tileColor: TaskItem.tileColors[widget.priority],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(widget.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        subtitle:
            Text(widget.description ?? '', overflow: TextOverflow.ellipsis),
        leading: Transform.scale(
          scale: 1.4,
          child: Checkbox(
              //If user checks off the item, prompt completion
              value: selected,
              onChanged: (bool? value) async {
                setState(() {
                  selected = true;
                });
                await widget.taskModel
                    .confirmCompletion(context, taskItem: widget);
                //If task was not marked as complete, uncheck completion
                setState(() {
                  selected = false;
                });
              }),
        ),
        //Toggleable stopwatch/timer
        trailing: TextButton(
            onPressed: () => setState(() {
                  _toggleTimer();
                }),
            child: Text(
              timerText ?? '0:00:00',
              style: const TextStyle(color: Colors.black, fontSize: 22),
            )));
  }
}
