//Types of menus to manage tasks
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

enum TaskMenu { add, edit }

class TaskTimer extends StatefulWidget {
  const TaskTimer({super.key});

  @override
  State<TaskTimer> createState() => _TaskTimerState();
}

class _TaskTimerState extends State<TaskTimer> {
  final StopWatchTimer _timer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onStopped: () {
      //Toggle flag indicating timer shouldn't run offline
    },
    onEnded: () {
      print('onEnded');
    },
  );
  @override
  void initState() {
    super.initState();
    //Initialize this timer running depending on flag
  }

  ///Toggles between starting and stopping the timer
  void _toggleTimer() {
    if (_timer.isRunning) {
      _timer.onStopTimer();
    } else {
      _timer.onStartTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: _timer.rawTime,
        initialData: _timer.rawTime.value,
        builder: (context, snap) {
          final time = snap.data!;
          final displayTime =
              StopWatchTimer.getDisplayTime(time, milliSecond: false);
          return TextButton(
              onPressed: _toggleTimer,
              child: Text(
                displayTime,
                style: const TextStyle(fontSize: 22, color: Colors.black),
              ));
        });
  }
}
