// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
//import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../task_model.dart';
//import 'package:image_picker/image_picker.dart';

//When user is signed in, display profile picture and settings (tbd)
// ignore: must_be_immutable
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

  // USER Stuff
  // FYI: User can be accessed universally through FirebaseAuth.instance.currentUser
  User? user = FirebaseAuth.instance.currentUser;

  // More accessors for user
  // name: user.displayName or user.updateDisplayName()
  // email: user.email or user.updateEmail()
  // profile photo: user.photoURL or user.updatePhotoURL()

  // I'm also working on profile images.... it's possible but I'm confused ~ Olivia
  /*
  var userImageFile;
  _getFromGallery() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile == null) return;
    setState(() {
      userImageFile = pickedFile.path;
      userImageStorageRef.putFile(userImageFile);
    });
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(30)),
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            radius: 60,
                          )),
                      SizedBox(
                          height: 30,
                          width: 150,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      Theme.of(context).colorScheme.primary)),
                              onPressed: (() {
                                /* ignore for now, dont delete!
                                 _getFromGallery();*/
                              }),
                              child: const Text('Set Profile Image'))),
                      Align(
                          key: null,
                          alignment: Alignment.centerLeft,
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                              child: Text(
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                  'Profile Information'))),
                      userInformation(
                          context: context,
                          icon: Icons.person,
                          editable: false,
                          label: 'Name',
                          body: user!.displayName),
                      userInformation(
                          context: context,
                          icon: Icons.mail,
                          editable: false,
                          label: 'Email',
                          body: user!.email),
                      SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () {
                            setState(() async {
                              // TODO: Implement user information changes
                              /* STILL WORKING ON THIS...
                              if (!editable) {
                                editable = true;
                              } else {
                                editable = false;
                              }*/
                            });
                          },
                          child: Text('Update Profile Information')),
                      SizedBox(height: 20),
                      userInformation(
                          context: context,
                          icon: Icons.lock,
                          editable: false,
                          label: 'Change Password',
                          body: ''),
                      ElevatedButton(
                          onPressed: () {}, child: Text('Change password')),
                    ]))),
                Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                        // LOG-OUT BUTTOON
                        onPressed: (() async {
                          await FirebaseAuth.instance.signOut();
                        }),
                        child: const Text('Log Out'))),
              ],
            )));
  }

  /// Container for user information text fields
  Widget userInformation(
      {required BuildContext context,
      required bool editable,
      required IconData icon,
      required String label,
      required String? body}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: TextField(
          readOnly: editable,
          decoration: InputDecoration(
              prefixIcon: Icon(icon),
              hintText: body,
              hintStyle: TextStyle(color: Colors.black))),
    );
  }
}
