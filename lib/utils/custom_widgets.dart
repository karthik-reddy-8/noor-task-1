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
      padding: const EdgeInsets.all(0.2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Container(
          color: color,
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                color: textColor,
                fontSize: App.textTheme.headline4!.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}