// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:final_project/profile_signed_in.dart';
import 'package:flutter/material.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Route for when user is logged off prompting for them to log in
// ignore: must_be_immutable
class ProfileSignedOut extends StatefulWidget {
  final TaskModel taskModel;
  const ProfileSignedOut({required this.taskModel, super.key});

  @override
  State<ProfileSignedOut> createState() => _ProfileSignedOutState();
}

class _ProfileSignedOutState extends State<ProfileSignedOut> {
  // Form key
  final _loginKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  // Login / signup panel
  final PanelController controller = PanelController();
  
  // Firebase user status
  User? user = FirebaseAuth.instance.currentUser;

  Widget _openForm(
      {required PanelController controller, required BuildContext context}) {
    String type = 'login';
    return Form(
        key: _loginKey,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
            onPressed: (() => controller.close()),
            icon: const Icon(Icons.close),
          ),
          SlidingSwitch(
            value: false,
            width: 250,
            onChanged: (value) {
              if (value == true) {
                type = 'signup';
              }
              if (value == false) {
                type = 'login';
              }
            },
            height: 45,
            textOn: 'Sign up',
            textOff: 'Log In',
            onTap: () {},
            onDoubleTap: () {},
            onSwipe: () {},
            colorOn: Colors.white,
            colorOff: Colors.white,
            buttonColor: const Color.fromARGB(255, 93, 135, 95),
            background: const Color.fromARGB(255, 159, 191, 160),
            inactiveColor: Colors.white,
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Email'),
            controller: emailCtrl,
            obscureText: false,
            validator: (email) {
              if (email == null || email.isEmpty) {
                return 'Please enter an email address';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Password'),
            controller: passwordCtrl,
            obscureText: true,
            validator: (password) {
              if (password == null || password.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
          ),
          ElevatedButton(
              onPressed: (() async {
                if (_loginKey.currentState!.validate()) {
                  _loginKey.currentState!.save();
                  UserCredential userCred;
                  // If user does not have an account, create one
                  if (type == 'signup') {
                    userCred = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: emailCtrl.text, password: passwordCtrl.text);
                    user = userCred.user;
                  }
                  // Login to account
                  userCred = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: emailCtrl.text, password: passwordCtrl.text);

                  user = userCred.user;
                }

                // Rebuild page to match user state
                setState(() => build(context));
              }),
              child: const Text('Submit'))
        ]));
  }

  Widget logInSignUpPanel() {
    return SlidingUpPanel(
        defaultPanelState: PanelState.CLOSED,
        controller: controller,
        minHeight: 0,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        panel: Center(
          child: Container(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 20),
              child: _openForm(controller: controller, context: context)),
        ),
        body: Column(children: [
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
              ElevatedButton(
                  onPressed: (() {
                    controller.open();
                  }),
                  child: const Text('Log In or Sign Up')),
            ],
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return (user == null)
        ? logInSignUpPanel()
        : ProfileSignedIn(taskModel: widget.taskModel);
  }
}

