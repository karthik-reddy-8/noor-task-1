import 'package:flutter/material.dart';
import 'package:flutter_calculator/constaints/colors.dart';
import 'package:flutter_calculator/utils/app.dart';
import 'package:flutter_calculator/utils/custom_widgets.dart';
import 'package:flutter_calculator/view_models/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.model}) : super(key: key);
  final HomeViewModel model;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeModel>(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (_, model, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            // Provide light theme.
            darkTheme: ThemeData.dark(),
            // Provide dark theme.
            themeMode: model.mode,
            // Decides which theme to show.
            home: Scaffold(
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: App.width * 0.04),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            App.columnSpacer(height: App.height * 0.07),
                            IconButton(
                                alignment: Alignment.topRight,
                                onPressed: () {
                                  model.toggleMode();
                                },
                                icon: const Icon(Icons.light_mode_outlined)),
                            App.columnSpacer(height: App.height * 0.15),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: App.width * 0.03),
                              alignment: Alignment.centerRight,
                              child: Text(
                                widget.model.userInput,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: customColor.labelColor),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: App.width * 0.03),
                              alignment: Alignment.centerRight,
                              child: Text(
                                widget.model.answer,
                                style: TextStyle(
                                    fontSize: 30,
                                    color: customColor.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ]),
                    ),
                    Expanded(
                      flex: 3,
                      child: GridView.builder(
                          itemCount: widget.model.buttons.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: App.width * 0.02,
                                  mainAxisSpacing: App.height * 0.01),
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return buildButton(
                                buttonTapped: () {
                                  widget.model.changeInitialValues();
                                },
                                buttonText: widget.model.buttons[index],
                                color: customColor.grey,
                                textColor: customColor.labelColor,
                              );
                            } else if (index == 1) {
                              return buildButton(
                                buttonTapped: () {
                                  widget.model
                                      .deleteUserInputs(widget.model.userInput);
                                },
                                buttonText: widget.model.buttons[index],
                                color: customColor.grey,
                                textColor: customColor.labelColor,
                              );
                            } else if (index == 2) {
                              return buildButton(
                                buttonTapped: () {
                                  widget.model.buttonIndex(index);
                                },
                                buttonText: widget.model.buttons[index],
                                color: customColor.white,
                                textColor: customColor.teal,
                              );
                            } else if (index == 16) {
                              return buildButton(
                                buttonText: widget.model.buttons[index],
                                color: widget.model
                                        .isOperator(widget.model.buttons[index])
                                    ? customColor.transparent
                                    : customColor.white,
                                textColor: customColor.labelColor,
                              );
                            } else if (index == 19) {
                              return buildButton(
                                buttonTapped: () {
                                  widget.model.equalPressed();
                                },
                                buttonText: widget.model.buttons[index],
                                color: customColor.white,
                                textColor: customColor.teal,
                              );
                            } else {
                              return buildButton(
                                buttonTapped: () {
                                  widget.model.buttonIndex(index);
                                },
                                buttonText: widget.model.buttons[index],
                                color: widget.model
                                        .isOperator(widget.model.buttons[index])
                                    ? customColor.white
                                    : customColor.transparent,
                                textColor: widget.model
                                        .isOperator(widget.model.buttons[index])
                                    ? customColor.teal
                                    : customColor.labelColor,
                              );
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        builder: (_, model, __) {
          return Home(model: model);
        });
  }
}

class ThemeModel with ChangeNotifier {
  ThemeMode _mode;

  ThemeMode get mode => _mode;

  ThemeModel({ThemeMode mode = ThemeMode.light}) : _mode = mode;

  void toggleMode() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
