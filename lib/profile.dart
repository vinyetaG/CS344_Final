import 'package:flutter/material.dart';
import 'task_model.dart';

class Profile extends StatelessWidget {
  final TaskModel taskModel;
  const Profile({required this.taskModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text("Profile", style: TextStyle(fontSize: 25)),
      ],
    );
  }
}
