import 'package:final_project/Profile/login_screen.dart';
import 'package:final_project/Profile/signed_in_screen.dart';
import 'package:flutter/material.dart';
import '../task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileLaunchScreen extends StatefulWidget {
  final TaskModel taskModel;
  const ProfileLaunchScreen({required this.taskModel, super.key});

  @override
  State<ProfileLaunchScreen> createState() => _ProfileLaunchScreenState();
}

class _ProfileLaunchScreenState extends State<ProfileLaunchScreen> {
  // TODO: Error with routing screens. The profile launch screen briefly shows up every time navigation is used. Probably should fix this.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          User? user = snapshot.data;
          if (user !=
              null /*can add email verificatiion using && FirebaseAuth.instance.currentUser.emailVerified == true*/) {
            print('User is logged in.');
            return SignedInScreen(taskModel: widget.taskModel);
          } else if (user == null) {
            print('User is not signed in.');
            return LoginScreen(taskModel: widget.taskModel);
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
