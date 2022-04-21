import 'package:flutter/material.dart';
import 'package:flutter_calculator/constants/colors.dart';
import 'package:flutter_calculator/constants/preferences.dart';
import 'package:flutter_calculator/utils/preference_helper.dart';
import 'package:flutter_calculator/utils/utilities.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    primaryColor: Colors.black,
    secondaryHeaderColor: Colors.white,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFFECEFF1),
    dividerColor: Colors.black12,
    disabledColor: const Color(0xFFECEFF1),
    textTheme: TextTheme(
        bodyText2: TextStyle(color: customColor.labelColor, fontSize: 25)),
  );

  final lightTheme = ThemeData(
    primaryColor: Colors.white,
    secondaryHeaderColor: Colors.transparent,
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    dividerColor: Colors.white54,
    disabledColor: Colors.transparent,
    textTheme: TextTheme(
        bodyText2: TextStyle(color: customColor.labelColor, fontSize: 25)),
  );

  ThemeData? _themeData;

  ThemeData? getTheme() => _themeData;

  ThemeNotifier() {
    readFromStorage(preference.themeMode).then((value) {
      printLog('value read from storage: ' + value.toString());
      var themeMode = value;
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        printLog('setting dark theme');
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    writeIntoStorage(preference.themeMode, 'dark');
    printLog('dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    writeIntoStorage(preference.themeMode, 'light');
    printLog('light');
    notifyListeners();
  }
}
