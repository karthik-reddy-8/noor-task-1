import 'package:flutter/cupertino.dart';
import 'package:flutter_calculator/utils/app.dart';

Widget buildButton({
  required Color color,
  required Color textColor,
  required String buttonText,
  VoidCallback? buttonTapped,
}){
  return GestureDetector(
    onTap: buttonTapped,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: App.width * 0.014, vertical: App.height * 0.006),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Container(
          color: color,
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                color: textColor,
                fontSize: App.textTheme.headline5!.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}