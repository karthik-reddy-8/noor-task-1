import 'package:flutter/material.dart';
import 'package:flutter_calculator/utils/app.dart';
import 'package:flutter_calculator/views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      navigatorKey: AppContext.navigatorState,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ); // MaterialApp
  }
}

