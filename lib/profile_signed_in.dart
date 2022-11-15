// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'task_model.dart';

//When user is signed in, display profile picture and settings (tbd)
// ignore: must_be_immutable
class ProfileSignedIn extends StatefulWidget {
  final TaskModel taskModel;
  const ProfileSignedIn({required this.taskModel, Key? key}) : super(key: key);

  @override
  State<ProfileSignedIn> createState() => _ProfileSignedInState();
}

class _ProfileSignedInState extends State<ProfileSignedIn> {
  // TO-DO: REPLACE all variables to NOT be hardcoded
  
  // NEW: User Name Variables
  String userName = 'Bayleef';
  bool userNameEnabler = false;
  TextEditingController userNameCtrl = TextEditingController();

  // NEW: User Email Variables
  String email = '';
  bool emailEnabler = false;
  TextEditingController emailCtrl = TextEditingController();

  // NEW: User Password Variables
  String password = '';
  bool passwordEnabler = false;
  TextEditingController passwordCtrl = TextEditingController();

  // NEW: User Avatar Variables
  String userAvatarUrl = 'lib/src/assets/images/bayleef.png';
  bool userAvatarEnabler = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[800],
        padding: const EdgeInsets.symmetric(horizontal: 30),
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
                height: 440,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(userAvatarUrl),
                      backgroundColor: Colors.green[300],
                      radius: 100,
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(userName,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold))),
                    const Text('Settings'),
                    // NEW: Listview for settings w/ name, email and password fields.
                    SizedBox(
                        height: 100,
                        child: ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(10),
                            children: <Widget>[
                              Row(
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text('Name: ')),
                                  Flexible(
                                      child: SizedBox(
                                          height: 20,
                                          child: TextField(
                                            controller: userNameCtrl,
                                            enabled: userNameEnabler,
                                            decoration: InputDecoration(
                                                hintText: userName,
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[800])),
                                          ))),
                                  IconButton(
                                    icon: Icon(Icons.create_rounded),
                                    iconSize: 20,
                                    onPressed: (() {
                                      setState(() {
                                        if (userNameEnabler) {
                                          // Change information
                                          userName = userNameCtrl.text;

                                          // Toggle edit mode OFF
                                          userNameEnabler = false;
                                        } else {
                                          // Toggle edit mode ON
                                          userNameEnabler = true;
                                        }
                                      });
                                    }),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text('Email: ')),
                                  Flexible(
                                      child: SizedBox(
                                          height: 20,
                                          child: TextField(
                                            controller: emailCtrl,
                                            enabled: emailEnabler,
                                            decoration: InputDecoration(
                                                hintText: email,
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[800])),
                                          ))),
                                  IconButton(
                                    icon: Icon(Icons.create_rounded),
                                    iconSize: 20,
                                    onPressed: (() {
                                      setState(() {
                                        if (emailEnabler) {
                                          // Change information
                                          email = emailCtrl.text;

                                          // Toggle edit mode OFF
                                          emailEnabler = false;
                                        } else {
                                          // Toggle edit mode ON
                                          emailEnabler = true;
                                        }
                                      });
                                    }),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text('Password: ')),
                                  Flexible(
                                      child: SizedBox(
                                          height: 20,
                                          child: TextField(
                                            controller: passwordCtrl,
                                            enabled: passwordEnabler,
                                            decoration: InputDecoration(
                                                hintText: password,
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[800])),
                                          ))),
                                  IconButton(
                                    icon: Icon(Icons.create_rounded),
                                    iconSize: 20,
                                    onPressed: (() {
                                      setState(() {
                                        if (passwordEnabler) {
                                          // Change information
                                          password = passwordCtrl.text;

                                          // Toggle edit mode OFF
                                          passwordEnabler = false;
                                        } else {
                                          // Toggle edit mode ON
                                          passwordEnabler = true;
                                        }
                                      });
                                    }),
                                  ),
                                ],
                              )
                            ])),
                    // TO-DO: TO BE CONTINUED
                  ]),
                )),
          ]),
          // TO-DO: Finish implementing the log-out button.
          Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: ElevatedButton( // LOG-OUT BUTTOON
                  onPressed: null, child: const Text('Log Out'))),
        ]));
  }
}
