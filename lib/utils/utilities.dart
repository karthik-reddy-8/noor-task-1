import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/colors.dart';

import 'App.dart';
late final BuildContext context;
void printLog(message) {
  if (!kReleaseMode) {
    debugPrint('$message');
  }
}
void showSnack({required String message}){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,
          style: TextStyle(color: customColor.white)),
      backgroundColor: customColor.black,
    ),
  );
}

SizedBox buildSizedBox({
  required Color avatarColor,
  required String image,
  required Color imageColor,
  required String projectName,
  required String numberOfTasks,
  required double height,
  required double width,
  required VoidCallback callback,
}){
  return SizedBox(
    height: App.height * 0.24,
    width: App.width * 0.43,
    child: InkWell(
      onTap: callback,
      child: Card(
        color: Colors.white,
        shadowColor: customColor.grey,
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              App.columnSpacer(height: App.height * 0.04),
              CircleAvatar(
                radius: 30,
                backgroundColor: avatarColor,
                child: Image.asset(
                  image,
                  height: height,
                  width: width,
                  fit: BoxFit.fill,
                  color: imageColor,
                ),
              ),
              App.columnSpacer(height: App.height * 0.01),
              Text(
                projectName,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              App.columnSpacer(height: App.height * 0.01),
              Text(numberOfTasks,
              style: TextStyle(
                color: customColor.labelColor
              ),)
            ],
          ),
        ),
      ),
    ),
  );
}