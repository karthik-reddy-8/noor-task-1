import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/colors.dart';
import 'package:flutter_todo_app/utils/App.dart';

void showSnack(String message) {
  ScaffoldMessenger.of(App.ctx!).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.black,
    ),
  );
}

Widget elevatedButton(
    {required String message,
      required VoidCallback? callBack,
      bool isFullWidth = true,
      Color? backgroundColor}) {
  return SizedBox(
    width: isFullWidth ? App.width : App.width * 0.6,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: backgroundColor ?? customColor.blue,
      ),
      onPressed: callBack,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: App.height * 0.018),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white
          ),
        ),
      ),
    ),
  );
}

Widget formFieldLabel({required String label}) {
  return Text(
    label,
    textAlign: TextAlign.start,
    style: TextStyle(
        fontSize: App.textTheme.subtitle2!.fontSize,
        color: customColor.labelColor),
  );
}