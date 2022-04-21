import 'package:flutter/material.dart';
import 'package:flutter_calculator/utils/utilities.dart';
import 'package:math_expressions/math_expressions.dart';

class HomeViewModel extends ChangeNotifier {
  var userInput = '';
  var answer = '';
  bool isDarkMode = false;

  final List<String> buttons = [
    'AC',
    'DEL',
    '%',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '+/_',
    '0',
    '.',
    '=',
  ];

  bool isOperator(String x) {
    if (x == '/' ||
        x == 'x' ||
        x == '-' ||
        x == '+' ||
        x == '=' ||
        x == '+/_') {
      return true;
    }
    return false;
  }

  Future<void> removeDoubleAuthOperators(String input) async {
    if (userInput.contains('%%') == true) {
      userInput = input.substring(0, userInput.length - 1);
    } else if (userInput.contains('++') == true) {
      userInput = input.substring(0, userInput.length - 1);
    } else if (userInput.contains('--') == true) {
      userInput = input.substring(0, userInput.length - 1);
    } else if (userInput.contains('xx') == true) {
      userInput = input.substring(0, userInput.length - 1);
    } else if (userInput.contains('//') == true) {
      userInput = input.substring(0, userInput.length - 1);
    } else if (userInput.contains('+/_+/_') == true) {
      userInput = input.substring(0, userInput.length - 3);
    } else if (userInput.contains('..') == true) {
      userInput = input.substring(0, userInput.length - 1);
    } else {
      userInput = userInput;
    }
    notifyListeners();
  }

  Future<void> changeInitialValues() async {
    userInput = '';
    answer = '0';
    notifyListeners();
  }

  Future<void> deleteUserInputs(String input) async {
    if (userInput.contains('+/_') == true) {
      userInput = input.substring(0, userInput.length - 3);
    } else {
      userInput = input.substring(0, userInput.length - 1);
    }
    notifyListeners();
  }

  Future<void> buttonIndex(int index) async {
    userInput += buttons[index];
    notifyListeners();
  }

  Future<void> equalPressed() async {
    String finalUserInput = userInput;
    finalUserInput = userInput.replaceAll('x', '*');
    printLog(finalUserInput);
    if (finalUserInput.isNotEmpty) {
      String input = finalUserInput.replaceAll('+/_', '-');
      Parser p = Parser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      answer = eval.toString();
    } else {
      return;
    }
    notifyListeners();
  }
}
