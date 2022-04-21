import 'package:flutter/material.dart';
import 'package:flutter_calculator/constants/colors.dart';
import 'package:flutter_calculator/utils/app.dart';
import 'package:flutter_calculator/utils/custom_widgets.dart';
import 'package:flutter_calculator/utils/utilities.dart';
import 'package:flutter_calculator/view_models/home_view_model.dart';
import 'package:flutter_calculator/utils/theme_manager.dart';
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
    return Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier themeNotifier, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeNotifier.getTheme(),
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: App.width * 0.04),
            child: Column(
              children: <Widget>[
                SizedBox(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        App.columnSpacer(height: App.height * 0.07),
                        IconButton(
                            alignment: Alignment.topRight,
                            onPressed: () {
                              printLog(widget.model.isDarkMode);
                              (widget.model.isDarkMode =
                                          !widget.model.isDarkMode) ==
                                      true
                                  ? themeNotifier.setDarkMode()
                                  : themeNotifier.setLightMode();
                            },
                            icon: widget.model.isDarkMode
                                ? const Icon(Icons.light_mode_outlined)
                                : const Icon(Icons.bedtime_outlined)),
                        App.columnSpacer(height: App.height * 0.08),
                        App.columnSpacer(height: App.height * 0.01),
                        Wrap(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: App.width * 0.03),
                              alignment: Alignment.centerRight,
                              child: Text(
                                widget.model.userInput.replaceAll('+/_', '-'),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: customColor.labelColor),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: App.width * 0.03,
                                  vertical: App.height * 0.001),
                              alignment: Alignment.centerRight,
                              child: Text(
                                widget.model.answer,
                                style: TextStyle(
                                    fontSize: 45,
                                    color: widget.model.isDarkMode
                                        ? customColor.white
                                        : customColor.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                      ]),
                ),
                Expanded(
                  flex: 3,
                  child: GridView.builder(
                      itemCount: widget.model.buttons.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                              color: Theme.of(context).disabledColor);
                        } else if (index == 1) {
                          return buildButton(
                              buttonTapped: () {
                                widget.model
                                    .deleteUserInputs(widget.model.userInput);
                              },
                              buttonText: widget.model.buttons[index],
                              color: Theme.of(context).disabledColor);
                        } else if (index == 2) {
                          return buildButton(
                            buttonTapped: () {
                              widget.model.buttonIndex(index);
                              widget.model.removeDoubleAuthOperators(
                                  widget.model.userInput);
                            },
                            buttonText: widget.model.buttons[index],
                            color: Theme.of(context).secondaryHeaderColor,
                            textColor: customColor.teal,
                          );
                        } else if (index == 16) {
                          return buildButton(
                            buttonText: widget.model.buttons[index],
                            buttonTapped: () {
                              widget.model.buttonIndex(index);
                              widget.model.removeDoubleAuthOperators(
                                  widget.model.userInput);
                            },
                          );
                        } else if (index == 18) {
                          return buildButton(
                            buttonTapped: () {
                              widget.model.buttonIndex(index);
                              widget.model.removeDoubleAuthOperators(
                                  widget.model.userInput);
                            },
                            buttonText: widget.model.buttons[index],
                            textColor: customColor.teal,
                          );
                        } else if (index == 19) {
                          return buildButton(
                            buttonTapped: () {
                              widget.model.equalPressed();
                            },
                            buttonText: widget.model.buttons[index],
                            color: Theme.of(context).secondaryHeaderColor,
                            textColor: customColor.teal,
                          );
                        } else {
                          return buildButton(
                            buttonTapped: () {
                              widget.model.buttonIndex(index);
                              widget.model
                                      .isOperator(widget.model.buttons[index])
                                  ? widget.model.removeDoubleAuthOperators(
                                      widget.model.userInput)
                                  : '';
                            },
                            buttonText: widget.model.buttons[index],
                            color: widget.model
                                    .isOperator(widget.model.buttons[index])
                                ? (themeNotifier.getTheme() != null
                                    ? customColor.white
                                    : customColor.transparent)
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
    });
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
