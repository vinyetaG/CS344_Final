import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../task_model.dart';
import 'main.dart';


/// SignedInScreen is the profile screen that users
/// are able to navigate to when logged into the app.
/// This contains the user's information such as
/// display name and email. The page also contains a
/// button that allows the user to log out of the app
/// Author: Olivia Ozbaki
/// Bugs: None that are apparent during testing.
class SignedInScreen extends StatefulWidget {
  final TaskModel taskModel;
  const SignedInScreen({required this.taskModel, Key? key}) : super(key: key);

  @override
  State<SignedInScreen> createState() => _SignedInScreenState();
}

class _SignedInScreenState extends State<SignedInScreen> {
  // TEXT EDITING CONTROLLERS
  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  // FirebaseAuth user
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Profile')),
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
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          // Card-appearing profile container
          child: Container(
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      spreadRadius: 5,
                      color: Colors.black.withOpacity(0.2),
                    )
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        const Color.fromARGB(175, 104, 149, 104)
                            .withOpacity(0.5),
                        Theme.of(context).colorScheme.secondary.withOpacity(0.7)
                      ]),
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Profile-card title
                    Align(
                        key: null,
                        alignment: Alignment.centerLeft,
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                            child: const Text(
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 34,
                                    fontWeight: FontWeight.w600),
                                'Profile Information'))),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // User's display name
                          userInformation(
                              context: context,
                              icon: Icons.person,
                              body: user!.displayName),
                          // User's email
                          userInformation(
                              context: context,
                              icon: Icons.mail,
                              body: user!.email),
                        ]),
                    // Log-out button
                    Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 10,
                              color: const Color.fromARGB(255, 196, 196, 196)
                                  .withOpacity(0.1),
                            )
                          ],
                        ),
                        child: MaterialButton(
                          onPressed: (() async {
                            var navigator = Navigator.of(context);
                            await FirebaseAuth.instance.signOut();
                            widget.taskModel.clearFields();
                            navigator.pushReplacement(MaterialPageRoute(
                                builder: (context) => TasksApp(
                                    routeIndex: 1,
                                    taskModel: widget.taskModel)));
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
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    'Log Out')),
                          ),
                        )),
                  ])),
        ),
      ),
    );
  }

  /// Container for user information text fields
  Widget userInformation(
      {required BuildContext context,
      required IconData icon,
      required String? body}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(color: Colors.white, icon),
        const SizedBox(width: 10),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.4, child: Text(body!)),
      ]),
    );
  }
}
