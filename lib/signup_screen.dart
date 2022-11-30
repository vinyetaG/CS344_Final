import 'signed_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../task_model.dart';

class SignUpScreen extends StatefulWidget {
  final TaskModel taskModel;
  const SignUpScreen({required this.taskModel, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameCtrl = TextEditingController();
    TextEditingController emailCtrl = TextEditingController();
    TextEditingController passwordCtrl = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
              decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                ]),
          )),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.6,
                        alignment: Alignment.topCenter,
                        child: const Text(
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                            'Create New Account')),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: signUpForm(
                          context: context,
                          taskModel: widget.taskModel,
                          nameCtrl: nameCtrl,
                          emailCtrl: emailCtrl,
                          passwordCtrl: passwordCtrl),
                    ),
                  ]),
            )));
  }
}

Widget signUpForm(
    {required BuildContext context,
    required TaskModel taskModel,
    required TextEditingController nameCtrl,
    required TextEditingController emailCtrl,
    required TextEditingController passwordCtrl}) {
  // ignore: no_leading_underscores_for_local_identifiers
  GlobalKey<FormState> _signUpKey = GlobalKey();

  double elementHeight = MediaQuery.of(context).size.height * 0.07;
  double elementWidth = MediaQuery.of(context).size.width * 0.6;
  double elementRadius = 30;
  double leftPadding = 20;

  return Form(
    key: _signUpKey,
    child: Column(
      children: [
        Stack(alignment: Alignment.topCenter, children: [
          Container(
            alignment: Alignment.topCenter,
            height: elementHeight,
            width: elementWidth,
            padding: EdgeInsets.only(left: leftPadding),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(elementRadius),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 25,
                      spreadRadius: -5)
                ]),
          ),
          Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(left: leftPadding),
              height: elementHeight * 1.5,
              width: elementWidth,
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: 'Name'),
                controller: nameCtrl,
                obscureText: false,
                validator: (name) {
                  if (name == null || name.isEmpty) {
                    return 'Please enter a name.';
                  }
                  return null;
                },
              ))
        ]),
        Stack(alignment: Alignment.topCenter, children: [
          Container(
            alignment: Alignment.topCenter,
            height: elementHeight,
            width: elementWidth,
            padding: EdgeInsets.only(left: leftPadding),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 25,
                      spreadRadius: -5)
                ]),
          ),
          Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(left: leftPadding),
              height: elementHeight * 1.5,
              width: elementWidth,
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: 'Email'),
                controller: emailCtrl,
                obscureText: false,
                validator: (email) {
                  if (email == null || email.isEmpty) {
                    return 'Please enter an email address';
                  }
                  return null;
                },
              ))
        ]),
        Stack(alignment: Alignment.topCenter, children: [
          Container(
            alignment: Alignment.topCenter,
            height: elementHeight,
            width: elementWidth,
            padding: const EdgeInsets.only(bottom: 5, left: 20),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(elementRadius),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 25,
                      spreadRadius: -5)
                ]),
          ),
          Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(left: leftPadding),
              height: elementHeight * 1.5,
              width: elementWidth,
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: 'Password'),
                controller: passwordCtrl,
                obscureText: true,
                validator: (password) {
                  if (password == null || password.isEmpty) {
                    return 'Please enter a password.';
                  }
                  return null;
                },
              ))
        ]),
        SizedBox(
            height: elementHeight,
            width: elementWidth,
            child: MaterialButton(
              onPressed: (() async {
                if (_signUpKey.currentState!.validate()) {
                  _signUpKey.currentState!.save();

                  // Login to account
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailCtrl.text, password: passwordCtrl.text);

                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      user.updateDisplayName(nameCtrl.text);
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            SignedInScreen(taskModel: taskModel)));
                  } on FirebaseAuthException catch (e) {
                    String loginError = e.message.toString();

                    SnackBar errorMessage =
                        SnackBar(content: Text(e.toString()));

                    if (e
                        .toString()
                        .contains('firebase_auth/email-already-in-use')) {
                      errorMessage = SnackBar(
                          content: Text('$loginError Please log-in instead.'));
                      Navigator.pop(context);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(errorMessage);
                  }
                }
              }),
              splashColor: Colors.black12,
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
              child: Ink(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary
                      ]),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        'Sign Up')),
              ),
            )),
      ],
    ),
  );
}
