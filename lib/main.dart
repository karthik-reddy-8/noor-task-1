import 'package:flutter/material.dart';
import 'package:flutter_calculator/views/home_page.dart';
import 'package:flutter_calculator/utils/theme_manager.dart';
import 'package:provider/provider.dart';

void main() {
  return runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              theme: theme.getTheme(),
              debugShowCheckedModeBanner: false,
              home: const HomePage(),
            ));
  }
}
