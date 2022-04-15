import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/colors.dart';
import 'package:flutter_todo_app/constraints/strings.dart';

import 'App.dart';

void printLog(message) {
  if (!kReleaseMode) {
    debugPrint('$message');
  }
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
}) {
  return SizedBox(
    height: App.height * 0.24,
    width: App.width * 0.43,
    child: InkWell(
      onTap: callback,
      child: Card(
        color: Colors.white,
        shadowColor: customColor.grey,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              App.columnSpacer(height: App.height * 0.01),
              Text(
                numberOfTasks,
                style: TextStyle(color: customColor.labelColor),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Wrap buildWorkCards(
    {required String title,
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback callback,
    required bool isTap}) {
  return Wrap(
    children: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: isTap ? backgroundColor : customColor.white,
        ),
        onPressed: callback,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Visibility(
              visible: (isTap == true) ? false : true,
              child: Container(
                height: App.width * 0.03,
                width: App.width * 0.03,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  color: isTap ? customColor.white : customColor.labelColor),
            )
          ],
        ),
      ),
    ],
  );
}

InkWell buildWorkButton({
  required String title,
  required Color backgroundColor,
  required Color iconColor,
  required VoidCallback callback,
}) {
  bool isTap = false;
  return InkWell(
    onTap: () {
      isTap = true;
      ChangeNotifier();
      callback();
    },
    child: Container(
      height: App.height * 0.05,
      width: App.width * 0.27,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: isTap ? backgroundColor : customColor.white,
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Visibility(
            visible: (isTap == true) ? false : true,
            child: Container(
              height: App.width * 0.03,
              width: App.width * 0.03,
              decoration: BoxDecoration(
                color: customColor.orange,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          App.rowSpacer(width: App.width * 0.02),
          Text(
            title,
            style: TextStyle(
                fontSize: 16,
                color: isTap ? customColor.white : customColor.labelColor),
          )
        ],
      ),
    ),
  );
}

Future showDialogBox({
  required BuildContext context,
  required VoidCallback callback,
}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: customColor.red,
                ),
                TextButton(
                    child: Text(strings.markAsCompleted),
                    onPressed: () {
                      callback;
                      Navigator.pop(context);
                    })
              ],
            ),
          ),
        );
      });
}
