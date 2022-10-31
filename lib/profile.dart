import 'package:flutter/material.dart';
import 'task_model.dart';

class Profile extends StatelessWidget {
  final TaskModel taskModel;
  const Profile({required this.taskModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.grey[850],
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  backgroundImage:
                      const AssetImage('lib/assets/images/798.png'),
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
      ]),
    ));
  }
}
