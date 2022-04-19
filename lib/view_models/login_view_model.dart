import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/preferences.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/utils/app.dart';
import 'package:flutter_todo_app/utils/custom_widgets.dart';
import 'package:flutter_todo_app/utils/preference_helper.dart';
import 'package:flutter_todo_app/utils/utilities.dart';
import 'package:flutter_todo_app/views/dashboard_page.dart';

class LoginViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  User? result = FirebaseAuth.instance.currentUser;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool isLoading = false;
  var secureText = true;

  Future<void> logInToFb(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    firebaseAuth
        .signInWithEmailAndPassword(
            email: emailController.text, password: passController.text)
        .then((result) async {
      DatabaseReference dbRefer = FirebaseDatabase.instance.ref();
      dbRefer
          .child('Users')
          .orderByKey()
          .equalTo(result.user?.uid)
          .once()
          .then((event) async {
        dynamic data = event.snapshot.value;
        writeIntoStorage(preference.name, data[result.user!.uid]['name']);
        writeIntoStorage(
            preference.photoUrl, data[result.user!.uid]['photoUrl']);
        writeIntoStorage(preference.phone, data[result.user!.uid]['phone']);
        writeIntoStorage(preference.email, data[result.user!.uid]['email']);
        printLog(data);
        App.pushReplacement(DashboardPage(
            userProfilePic: data[result.user!.uid]['photoUrl'],
            userName: data[result.user!.uid]['name']));
      });
    }).catchError((err) {
      showSnack(strings.invalidUsername);
      isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() async {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
}
