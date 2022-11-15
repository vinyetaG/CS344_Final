// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:final_project/profile_signed_in.dart';
import 'package:flutter/material.dart';
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
  // VARIABLES
  static User? user = null;  // NEW
  static String email = 'viciousclaw3@gmail.com'; // NEW
  static String password = 'password'; // NEW

  // NEW: _logIn() logs the user in on button press.
  _logIn() async {
    try {
      /*  !!! COMMENTED OUT FOR FUTURE TESTING AND IMPLEMENTATION !!!
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            // TEXT CONTROLLERS
            TextEditingController emailController = TextEditingController();
            TextEditingController passwordController = TextEditingController();

            return AlertDialog(
                title: const Text('Log In'),
                content: Column(children: [
                  TextField(
                      decoration: InputDecoration(hintText: 'Email'),
                      controller: emailController),
                  TextField(
                      decoration: InputDecoration(hintText: 'Password'),
                      controller: passwordController),
                  ElevatedButton(
                      onPressed: (() => Navigator.pop(context)),
                      child: const Text('Cancel')),
                  ElevatedButton(
                      onPressed: (() {
                        if (emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          email = emailController.text;
                          password = passwordController.text;
                          Navigator.pop(context);
                        }
                      }),
                      child: const Text('Submit')),
                ]));
          });*/
      // NEW: Save user credentials from information entered by user
      UserCredential userCreds = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _ProfileSignedOutState.email,
              password: _ProfileSignedOutState.password);
              
      // NEW: Store user credentials in a global user variable
      user = userCreds.user;
      print('user = ${_ProfileSignedOutState.user}');
      
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
  }

  // NEW: logIn is the screen that will be shown under profile navigation if the user
  // has not yet logged in.
  Widget logIn() {
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
            ElevatedButton(
                onPressed: () async {
                  await _logIn();
                  setState(() {
                  // NEW: Rebuild widget (profile screen) after button press
                    build(context);
                  });
                },
                child: Text('Login')),
            const SizedBox(width: 30),
            ElevatedButton(onPressed: null, child: Text('Sign up')),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //  NEW: If user is null, login has not occured. Return login screen.
    //  NEW: Else return profile logged in screen.
    return (user == null)
        ? logIn()
        : ProfileSignedIn(taskModel: widget.taskModel);
  }
}
