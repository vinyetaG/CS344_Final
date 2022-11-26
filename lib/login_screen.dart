import 'package:final_project/Profile/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  // Firebase user status
  final FirebaseAuth auth = FirebaseAuth.instance;

  // TODO: Implement profile picture
  // TODO: Implement settings fields
  // TODO: OPTIONAL - Redesign card once elements are working?
  // TODO: Something is wrong with my text fields. They're centered but only in certain window sizes... not sure why they won't center right :(((

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
                child: Column(children: [
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Image(
                    image: AssetImage('lib/src/assets/images/timerIcon.png'),
                    width: 100,
                    height: 100,
                  )),
              const Text('Welcome to Time-Tips!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: (FontWeight.bold),
                    fontSize: 24,
                  )),
              const SizedBox(height: 20),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: loginForm(
                      context: context,
                      emailCtrl: emailCtrl,
                      passwordCtrl: passwordCtrl)),
              const SizedBox(height: 10),
              registerBar(widget.taskModel, context),
            ]))));
  }
}

Widget loginForm(
    {required BuildContext context,
    required TextEditingController emailCtrl,
    required TextEditingController passwordCtrl}) {
  // Form key
  // ignore: no_leading_underscores_for_local_identifiers
  final _loginKey = GlobalKey<FormState>();
  return Form(
      key: _loginKey,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Stack(children: [
          Container(
            height: 50,
            width: 450,
            padding: const EdgeInsets.only(bottom: 5, left: 20),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30)),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 20),
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
        Stack(children: [
          Container(
            height: 50,
            width: 450,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30)),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 20),
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
                    return 'Please enter a password';
                  }
                  return null;
                },
              )),
        ]),
        const SizedBox(height: 10),
        SizedBox(
            height: 50,
            width: 450,
            child: MaterialButton(
              onPressed: (() async {
                if (_loginKey.currentState!.validate()) {
                  _loginKey.currentState!.save();

                  // Login to account
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailCtrl.text, password: passwordCtrl.text);
                  } on FirebaseAuthException catch (e) {
                    String loginError = e.message.toString();
                    SnackBar errorMessage = SnackBar(content: Text(loginError));
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
                        'Login')),
              ),
            )),
      ]));
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
