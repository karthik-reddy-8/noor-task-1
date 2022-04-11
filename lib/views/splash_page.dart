import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/colors.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/utils/app.dart';
import 'package:flutter_todo_app/utils/custom_widgets.dart';

import 'login_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColor.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              strings.appName,
              style: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            App.columnSpacer(),
            Center(
              child: Image.asset(
                'assets/images/ic_task.png',
                width: App.width * 0.5,
              ),
            ),
            App.columnSpacer(),
            App.columnSpacer(),
            Text(
              strings.reminder,
              style:
                  const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            Text(
              strings.reminderText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            // App.columnSpacer(height: App.height * 0.1),
            elevatedButton(
                message: strings.getStarted,
                callBack: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const LoginPage()));
                  // App.pushReplacement(const LoginPage());
                },
                backgroundColor: customColor.green,
                isFullWidth: false),
          ],
        ),
      ),
    );
  }
}
