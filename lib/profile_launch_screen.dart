import 'login_screen.dart';
import 'signed_in_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          User? user = snapshot.data;
          if (user !=
              null /*can add email verificatiion using && FirebaseAuth.instance.currentUser.emailVerified == true*/) {
            return SignedInScreen(taskModel: widget.taskModel);
          } else if (user == null) {
            return LoginScreen(taskModel: widget.taskModel);
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
