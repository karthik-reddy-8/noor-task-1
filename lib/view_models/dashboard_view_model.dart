import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/preferences.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/database/database.dart';
import 'package:flutter_todo_app/database/entity/task.dart';
import 'package:flutter_todo_app/enums/work_type.dart';
import 'package:flutter_todo_app/utils/custom_widgets.dart';
import 'package:flutter_todo_app/utils/preference_helper.dart';
import 'package:flutter_todo_app/utils/utilities.dart';
import 'package:flutter_todo_app/widgets/commons/validations.dart';

class DashboardViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? selectedDateTime = DateTime.now().toString().split(' ')[0];
  String? selectedTime = DateTime.now().hour.toString().split(' ')[0] + ':00';
  String? name;
  String? imageUrl;

  final DatabaseReference dbRefer = FirebaseDatabase.instance.ref();
  final FirebaseAuth auth = FirebaseAuth.instance;
  WorkType currentWorkType = WorkType.personal;
  TodoDatabase? database;
  int? count;
  final formKey = GlobalKey<FormState>();
  TextEditingController taskController = TextEditingController();

  Future<dynamic> initCall() async {
    await getDataFromPrefs();
    await getCount(strings.personal);
    printLog('count: $count');
    notifyListeners();
  }

  Future<void> getDataFromPrefs() async {
    name = await readFromStorage(preference.name);
    imageUrl = await readFromStorage(preference.photoUrl);
    notifyListeners();
  }

  Future<int?> getCount(String type) async {
    $FloorTodoDatabase
        .databaseBuilder('Todo_database.db')
        .build()
        .then((value) async {
      database = value;
    });
    int? counter = await database?.todoDAO.getTodoCountByType('Personal');
    notifyListeners();
    printLog('counter: $counter');
    return counter;
  }

  Future<void> changeWorkStatus(WorkType workType) async {
    currentWorkType = workType;
    printLog('Work type: $currentWorkType');
    notifyListeners();
  }

  Future<void> setDateTime(BuildContext context) async {
    DateTime? selectedDate = await showDateTimePickerWidget(context);
    if (selectedDate != null) {
      selectedDateTime = selectedDate.year.toString() +
          '-' +
          selectedDate.month.toString() +
          '-' +
          selectedDate.day.toString() +
          ',';
      selectedTime = selectedDate.hour.toString() +
          ':' +
          selectedDate.minute.toString() +
          ' - ${selectedDate.hour + 1}:00';
      printLog('selectedDateTime: $selectedTime');
      // if (selectedDate.day.toString() == DateTime.now().day.toString()) {
      //   selectedDateTime = 'Today';
      //   printLog('selectedDateTime: $selectedDateTime');
      // } else {
      //   return;
      // }
    }
    notifyListeners();
  }


  Future<dynamic> addTodo() async {
    $FloorTodoDatabase
        .databaseBuilder('Todo_database.db')
        .build()
        .then((value) async {
      database = value;
      await addTodoItem(database!);
      notifyListeners();
    });
  }

  Future<int?> getAllTodos(String workType) async {
    $FloorTodoDatabase
        .databaseBuilder('Todo_database.db')
        .build()
        .then((value) async {
      database = value;
      notifyListeners();
    });
    return await database?.todoDAO.findTodoByType(workType).then((value) => value.length);
  }

  Future<dynamic> addTodoItem(TodoDatabase database) async {
    String typeOfWork = validation.validateTaskType(currentWorkType);
    Todo todo = Todo(
        title: taskController.text.toString(),
        type: typeOfWork,
        date: selectedDateTime.toString() + selectedTime.toString(),
        finished: false);
    printLog('Todo: ${todo.title}, ${todo.type}, ${todo.finished}');
    return await database.todoDAO.insertTodo(todo);
  }
}
