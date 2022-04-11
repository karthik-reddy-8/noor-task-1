import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/colors.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/views/dashboard_page.dart';

class LoginViewModel extends ChangeNotifier{
  final formKey = GlobalKey<FormState>();
  User? result = FirebaseAuth.instance.currentUser;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController(text: 'noormahammad852@gmail.com');
  TextEditingController passController = TextEditingController(text: 'Noor@143');
  bool isLoading = false;
  var secureText = true;

  logInToFb(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    firebaseAuth
        .signInWithEmailAndPassword(
        email: emailController.text, password: passController.text)
        .then((result) async {
          // DatabaseReference dbRefer = FirebaseDatabase.instance.ref();
          // dbRefer.child('Users').orderByKey()
          //     .equalTo(result.user?.uid)
          //     .once()
          //     .then((event) {
          //       dynamic data = event.snapshot.value;
          //       print(data);
          // });
      Navigator.pushReplacement(context,
               MaterialPageRoute(builder: (context) => const DashboardPage()));
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          strings.invalidUsername,
          style: TextStyle(color: customColor.white),
        ),
        backgroundColor: customColor.black,
      ));
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