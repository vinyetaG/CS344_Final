// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'task_model.dart';

//When user is signed in, display profile picture and settings (tbd)
class ProfileSignedIn extends StatelessWidget {
  final TaskModel taskModel;
  const ProfileSignedIn({required this.taskModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Profile",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.green[200],
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                width: 250,
                child: Column(children: [
                  CircleAvatar(
                    backgroundImage: null,
                    backgroundColor: Colors.green[300],
                    radius: 100,
                  ),
                  const Text("Clash",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold))
                ]))
          ]),
          const Text("Settings",
              style: TextStyle(color: Colors.white, fontSize: 30)),
        ],
      ),
    );
  }
}
