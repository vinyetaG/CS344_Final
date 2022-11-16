// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:final_project/profile_signed_in.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sliding_switch/sliding_switch.dart';

//Route for when user is logged off prompting for them to log in
// ignore: must_be_immutable
class ProfileSignedOut extends StatefulWidget {
  final TaskModel taskModel;
  const ProfileSignedOut({required this.taskModel, super.key});

  @override
  State<ProfileSignedOut> createState() => _ProfileSignedOutState();
}

class _ProfileSignedOutState extends State<ProfileSignedOut> {
  // VARIABLES
  final _loginKey = GlobalKey<FormState>();
  // ignore: avoid_init_to_null
  static User? user = null;

  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  final TextEditingController newEmailCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController newPasswordCtrl = TextEditingController();

  // NEW: _logIn() logs the user in on button press.
  Future<User?> logInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      // NEW: Save user credentials from information entered by user
      UserCredential userCreds = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCreds.user;
    } on FirebaseAuthException catch (e) {
      // TO-DO: Convert print statements into a snackbar notification.
      if (e.code == 'user-not-found') {
        // ignore: avoid_print
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        // ignore: avoid_print
        print('Wrong password provided for that user.');
      }
    }
    _ProfileSignedOutState.user = user;
    return user;
  }

  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // ignore: avoid_print
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // ignore: avoid_print
        print('The account already exists for that email.');
      } else {
        // ignore: avoid_print
        print(e);
      }
    }
    _ProfileSignedOutState.user = user;
    return user;
  }

  Widget? _openForm({required PanelController controller}) {
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
            decoration: InputDecoration(hintText: 'Email'),
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
            decoration: InputDecoration(hintText: 'Password'),
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
              onPressed: (() {
                if (_loginKey.currentState!.validate()) {
                  _loginKey.currentState!.save();

                  // If user does not have an account, create one
                  String snackBarText = '';
                  SnackBar snackBar = SnackBar(content: Text(snackBarText));

                  if (type == 'signup') {
                    snackBarText = 'Now creating your Time-Tips Account...';
                    setState(() {
                      createUserWithEmailAndPassword(
                        email: emailCtrl.text,
                        password: passwordCtrl.text,
                      );
                    });
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }

                  snackBarText = 'Logging into Time-tips...';
                  snackBar = SnackBar(content: Text(snackBarText));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  // Login to account
                  logInUsingEmailPassword(
                    email: emailCtrl.text,
                    password: passwordCtrl.text,
                  ).then((_) {
                    setState(() {
                      build(context);
                    });
                  }).then((_) => controller.close());
                }
              }),
              child: const Text('Submit'))
        ]));
  }

// NEW: logIn is the screen that will be shown under profile navigation if the user
// has not yet logged in.
  Widget logIn() {
    PanelController controller = PanelController();

    return SlidingUpPanel(
        defaultPanelState: PanelState.CLOSED,
        controller: controller,
        minHeight: 0,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        panel: Center(
          child: Container(
              padding: EdgeInsets.fromLTRB(50, 10, 50, 20),
              child: _openForm(controller: controller)),
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
                    _openForm(controller: controller);
                  }),
                  child: Text('Login')),
              const SizedBox(width: 30),
              ElevatedButton(
                  onPressed: (() async {
                    controller
                        .open()
                        .then((_) => _openForm(controller: controller));
                  }),
                  child: Text('Sign up')),
            ],
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    // If user is null, login has not occured. Return login screen.
    // Else return profile logged in screen.
    return (user == null)
        ? logIn()
        : ProfileSignedIn(taskModel: widget.taskModel);
  }
}

