import 'package:flutter/material.dart';
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
    if (x == '/' || x == 'x' || x == '-' || x == '+' || x == '=' || x == '+/_') {
      return true;
    }
    return false;
  }

  Future<void> changeInitialValues() async{
    userInput = '';
    answer = '0';
    notifyListeners();
  }

  Future<void> deleteUserInputs(String input) async{
    userInput =
        input.substring(0, userInput.length - 1);
    notifyListeners();
  }

  Future<void> buttonIndex(int index) async{
    userInput += buttons[index];
    notifyListeners();
  }

  Future<void> equalPressed() async{
    String finalUserInput = userInput;
    finalUserInput = userInput.replaceAll('x', '*');
    finalUserInput = userInput.replaceAll('+/_', '-');
    Parser p = Parser();
    Expression exp = p.parse(finalUserInput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    answer = eval.toString();
    notifyListeners();
  }
}
