import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../task_model.dart';

///Name: Olivia Ozbaki
///Date: 12/14/2022
///Description: SignUpScreen is the screen that allows the user to
///             register to create an account.
///Bugs: N/A
///Reflection: At first we had some problems because the texteditingcontrollers
///            were in the build method but it was fine when we sorted it out.
class SignUpScreen extends StatefulWidget {
  final TaskModel taskModel;
  const SignUpScreen({required this.taskModel, super.key});

  @override
  State<SignUpScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignUpScreen> {
  static final GlobalKey<FormState> _signUpKey = GlobalKey();

  // Text Editing Controllers
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Sizing variables
    double elementHeight = MediaQuery.of(context).size.height * 0.07;
    double elementWidth = MediaQuery.of(context).size.width * 0.6;
    double elementRadius = 30;
    double leftPadding = 20;

    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Register')),
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
        body: SingleChildScrollView(
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
                      child: Form(
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
                                    borderRadius:
                                        BorderRadius.circular(elementRadius),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 25,
                                          spreadRadius: -5)
                                    ]),
                              ),
                              Container(
                                  alignment: Alignment.topCenter,
                                  padding: EdgeInsets.only(
                                      top: 11, left: leftPadding),
                                  height: elementHeight * 1.5,
                                  width: elementWidth,
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.white),
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
                                  padding: EdgeInsets.only(
                                      top: 11, left: leftPadding),
                                  height: elementHeight * 1.5,
                                  width: elementWidth,
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.white),
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
                                padding:
                                    const EdgeInsets.only(bottom: 5, left: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius:
                                        BorderRadius.circular(elementRadius),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 25,
                                          spreadRadius: -5)
                                    ]),
                              ),
                              Container(
                                  alignment: Alignment.topCenter,
                                  padding: EdgeInsets.only(
                                      top: 11, left: leftPadding),
                                  height: elementHeight * 1.5,
                                  width: elementWidth,
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        hintText: 'Password'),
                                    controller: passwordCtrl,
                                    obscureText: true,
                                    validator: (password) {
                                      if (password == null ||
                                          password.isEmpty) {
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
                                        var navigator = Navigator.of(context);
                                        await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                                email: emailCtrl.text,
                                                password: passwordCtrl.text);

                                        User? user =
                                            FirebaseAuth.instance.currentUser;
                                        if (user != null) {
                                          await user
                                              .updateDisplayName(nameCtrl.text);
                                        }
                                        navigator.pop();
                                        navigator.pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) => TasksApp(
                                                    routeIndex: 1,
                                                    taskModel:
                                                        widget.taskModel)));
                                      } on FirebaseAuthException catch (e) {
                                        SnackBar errorMessage = SnackBar(
                                            content: Text(e.toString()));

                                        if (e.toString().contains(
                                            'firebase_auth/email-already-in-use')) {
                                          errorMessage = const SnackBar(
                                              content: Text(
                                                  'Account already exists. Please log-in instead.'));
                                          Navigator.pop(context);
                                        }

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(errorMessage);
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
                                            Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary
                                          ]),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: const Text(
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            'Sign Up')),
                                  ),
                                )),
                          ],
                        ),
                      ),
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
    required TextEditingController passwordCtrl,
    required key}) {
  // ignore: no_leading_underscores_for_local_identifiers

  double elementHeight = MediaQuery.of(context).size.height * 0.07;
  double elementWidth = MediaQuery.of(context).size.width * 0.6;
  double elementRadius = 30;
  double leftPadding = 20;

  return Form(
    key: key,
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
              padding: EdgeInsets.only(top: 11, left: leftPadding),
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
              padding: EdgeInsets.only(top: 11, left: leftPadding),
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
              padding: EdgeInsets.only(top: 11, left: leftPadding),
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
                if (key.currentState!.validate()) {
                  key.currentState!.save();
                  // Login to account
                  try {
                    var navigator = Navigator.of(context);
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailCtrl.text, password: passwordCtrl.text);

                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await user.updateDisplayName(nameCtrl.text);
                    }
                    navigator.pop();
                    navigator.pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            TasksApp(routeIndex: 1, taskModel: taskModel)));
                  } on FirebaseAuthException catch (e) {
                    SnackBar errorMessage =
                        SnackBar(content: Text(e.toString()));

                    if (e
                        .toString()
                        .contains('firebase_auth/email-already-in-use')) {
                      errorMessage = const SnackBar(
                          content: Text(
                              'Account already exists. Please log-in instead.'));
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
