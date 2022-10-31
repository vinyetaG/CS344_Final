// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'task_model.dart';

class ProfileSignedOut extends StatelessWidget {
  final TaskModel taskModel;
  const ProfileSignedOut({required this.taskModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
              width: 300,
              height: 330,
              child: Column(children: [
                Text("Welcome to Time-Tips!",
                    style: TextStyle(
                        fontWeight: (FontWeight.bold),
                        fontSize: 24,
                        color: Colors.grey[200]) //set up themes later,
                    ),
                Text(
                  "Please sign in or sign up to get started.",
                  style: TextStyle(color: Colors.grey[200]),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Image(
                      image: AssetImage('lib/assets/images/timerIcon.png'),
                      width: 150,
                      height: 150,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: null,
                        child: Text("Login",
                            style: TextStyle(color: Colors.grey[200]))),
                    SizedBox(width: 30),
                    ElevatedButton(
                        onPressed: null,
                        child: Text("Sign up",
                            style: TextStyle(color: Colors.grey[200])))
                  ],
                )
              ])),
        ));
  }
}
