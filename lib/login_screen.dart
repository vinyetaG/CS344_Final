import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../task_model.dart';
//import 'package:final_project/src/themedata.dart';

class LoginScreen extends StatefulWidget {
  final TaskModel taskModel;
  const LoginScreen({required this.taskModel, Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Text controllers
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  // Firebase user status
  final FirebaseAuth auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _loginKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // TextFormField sizing
    double elementHeight = MediaQuery.of(context).size.height * 0.07;
    double elementWidth = MediaQuery.of(context).size.width * 0.6;
    double elementRadius = 30;
    double leftPadding = 20;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                ]),
            )),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.question_mark_rounded))
            ]),
        body: Padding(
            padding: EdgeInsets.fromLTRB(
                30, MediaQuery.of(context).size.height * 0.2, 30, 30),
            child: Column(children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                alignment: Alignment.topLeft,
                child: const Text(
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                    'Welcome,'),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  alignment: Alignment.topLeft,
                  child: const Text(
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                      'Please sign in to continue.')),
              const SizedBox(height: 20),
              Form(
                key: _loginKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Email Field
                      Stack(alignment: Alignment.topCenter, children: [
                        // Opaque Background
                        Container(
                          alignment: Alignment.topCenter,
                          height: elementHeight,
                          width: elementWidth,
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
                        // Textfield Container (Shows validation below opaque area)
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
                              controller: _emailCtrl,
                              obscureText: false,
                              validator: (email) {
                                if (email == null || email.isEmpty) {
                                  return 'Please enter an email address';
                                }
                                return null;
                              },
                            ))
                      ]),

                      // Password Field
                      Stack(alignment: Alignment.topCenter, children: [
                        // Opaque Background
                        Container(
                          alignment: Alignment.topCenter,
                          height: elementHeight,
                          width: elementWidth,
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

                        // Textfield Container (Shows validation below opaque area)
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
                              controller: _passwordCtrl,
                              obscureText: true,
                              validator: (password) {
                                if (password == null || password.isEmpty) {
                                  return 'Please enter a password';
                                }
                                return null;
                              },
                            )),
                      ]),

                      const SizedBox(height: 10),

                      SizedBox(
                          height: elementHeight,
                          width: elementWidth,
                          child: MaterialButton(
                            onPressed: (() async {
                              if (_loginKey.currentState!.validate()) {
                                _loginKey.currentState!.save();

                                // Login to account
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: _emailCtrl.text,
                                          password: _passwordCtrl.text);
                                } on FirebaseAuthException catch (e) {
                                  String loginError = e.message.toString();
                                  SnackBar errorMessage =
                                      SnackBar(content: Text(loginError));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(errorMessage);
                                }
                              }
                            }),
                            splashColor: Colors.black12,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(elementRadius),
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
                                borderRadius:
                                    BorderRadius.circular(elementRadius),
                              ),
                              child: Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      'Sign In')),
                            ),
                          )),
                    ]),
              ),
              const SizedBox(height: 10),
              registerBar(widget.taskModel, context),
            ])));
  }
}

Widget registerBar(taskModel, context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          'Not a member? '),
      InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SignUpScreen(taskModel: taskModel))),
          child: Text(
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
              'Register now.')),
    ],
  );
}
