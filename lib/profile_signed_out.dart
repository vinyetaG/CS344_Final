// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'task_model.dart';

//Route for when user is logged off prompting for them to log in
class ProfileSignedOut extends StatelessWidget {
  final TaskModel taskModel;
  const ProfileSignedOut({required this.taskModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 50,
        ),
        const Text(
            'Welcome to Time-Tips!\nPlease sign in or sign up to get started.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: (FontWeight.bold),
              fontSize: 24,
            )),
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Image(
              image: AssetImage('lib/src/assets/images/timerIcon.png'),
              width: 150,
              height: 150,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: null, child: Text('Login')),
            const SizedBox(width: 30),
            ElevatedButton(onPressed: null, child: Text('Sign up')),
          ],
        )
      ],
    );
  }
}
