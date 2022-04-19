import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_app/constraints/colors.dart';
import 'package:flutter_todo_app/utils/app.dart';
import 'package:flutter_todo_app/views/splash_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: AppContext.navigatorState,
      title: 'Todo Application',
      theme: ThemeData(
        primarySwatch: customColor.swatchColor,
      ),
      home: const SplashScreen(),
    );
  }
}

