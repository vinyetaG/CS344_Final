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
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context)),
            title: const Text('Register')),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Create an account to get started.'),
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
  return Form(
    key: _signUpKey,
    child: Column(
      children: [
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
        const SizedBox(height: 10),
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
        const SizedBox(height: 10),
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
        const SizedBox(height: 20),
        SizedBox(
            height: 50,
            width: 450,
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

Widget customContainerForTextField() {
  return Container();
}

TextField customTextField() {
  return const TextField();
}
