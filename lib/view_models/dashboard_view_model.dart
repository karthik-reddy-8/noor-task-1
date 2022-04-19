import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/preferences.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/database/dao/task_dao.dart';
import 'package:flutter_todo_app/database/database.dart';
import 'package:flutter_todo_app/database/entity/task.dart';
import 'package:flutter_todo_app/enums/work_type.dart';
import 'package:flutter_todo_app/utils/app.dart';
import 'package:flutter_todo_app/utils/custom_widgets.dart';
import 'package:flutter_todo_app/utils/preference_helper.dart';
import 'package:flutter_todo_app/utils/utilities.dart';
import 'package:flutter_todo_app/views/user_profie_page.dart';
import 'package:flutter_todo_app/widgets/commons/validations.dart';

class DashboardViewModel extends ChangeNotifier {
  bool isLoading = false;
  String selectedDateTime = DateTime.now().toString().split(' ')[0];
  String selectedTime = DateTime.now().hour.toString().split(' ')[0] + ':00';
  String? todoCreatedDateTime;
  String? name;
  String? imageUrl;
  int todayTodosCount = 0;

  final DatabaseReference dbRefer = FirebaseDatabase.instance.ref();
  final FirebaseAuth auth = FirebaseAuth.instance;
  WorkType currentWorkType = WorkType.personal;
  TodoDatabase? database;
  int personalTodosCount = 0;
  int workTodosCount = 0;
  int meetingTodosCount = 0;
  int shoppingTodosCount = 0;
  String? todayTodoTitle;
  String? todayTodoTime;
  final formKey = GlobalKey<FormState>();
  TextEditingController taskController = TextEditingController();

  Future<dynamic> initCall() async {
    await getDataFromPrefs();
    await getPersonalTodoCount(strings.personal);
    await getWorkTodoCount(strings.work);
    await getMeetingTodoCount(strings.meeting);
    await getShoppingTodoCount(strings.shopping);
    await getAll('8:10');
    notifyListeners();
  }

  Future<dynamic> getAllTodosByType() async {
    await getPersonalTodoCount(strings.personal);
    await getWorkTodoCount(strings.work);
    await getMeetingTodoCount(strings.meeting);
    await getShoppingTodoCount(strings.shopping);
    notifyListeners();
  }

  Future<void> getDataFromPrefs() async {
    name = await readFromStorage(preference.name);
    imageUrl = await readFromStorage(preference.photoUrl);
    notifyListeners();
  }

  Future<void> getAll(String time) async {
    database =
        await $FloorTodoDatabase.databaseBuilder('Todo_database.db').build();
    TodoDAO dao = database!.todoDAO;
    var result = await dao.findAllTodos();
    int length = result.length;
    printLog('length: $length');
    List<Todo> list = [];
    for (int i = 0; i < length; i++) {
      list.add(result[i]);
    }
    List<Todo> todayList = [];
    for (var element in list) {
      if (element.date
          .contains('${DateTime.now().toString().split(' ')[0]} $time')) {
        printLog(
            'Today: ${DateTime.now().toString().split(' ')[0]} ${DateTime.now().toString().split(' ')[1]}');
        printLog(element.title);
      } else if (element.date
          .contains(DateTime.now().toString().split(' ')[0])) {
        printLog("Today's Todo: ${element.title}");
        todayTodoTitle = element.title;
        todayTodoTime = element.date;
        todayList.add(element);
        printLog("Today's list count: ${todayList.length}");
        todayTodosCount = todayList.length;
        printLog('todayTodosCount: $todayTodosCount');
        notifyListeners();
      } else {
        printLog('No data found');
      }
    }
    notifyListeners();
  }

  Future<void> getPersonalTodoCount(String type) async {
    database =
        await $FloorTodoDatabase.databaseBuilder('Todo_database.db').build();
    TodoDAO dao = database!.todoDAO;
    var result = await dao.findTodoByType(type);
    printLog(result[0].type);
    personalTodosCount = result.length;
    printLog('counter: $personalTodosCount');
    notifyListeners();
  }

  Future<void> getWorkTodoCount(String type) async {
    database =
        await $FloorTodoDatabase.databaseBuilder('Todo_database.db').build();
    TodoDAO dao = database!.todoDAO;
    var result = await dao.findTodoByType(type);
    workTodosCount = result.length;
    printLog('counter: $personalTodosCount');
    notifyListeners();
  }

  Future<void> getMeetingTodoCount(String type) async {
    database =
        await $FloorTodoDatabase.databaseBuilder('Todo_database.db').build();
    TodoDAO dao = database!.todoDAO;
    var result = await dao.findTodoByType(type);
    printLog(result[0].type);
    meetingTodosCount = result.length;
    printLog('counter: $personalTodosCount');
    notifyListeners();
  }

  Future<void> getShoppingTodoCount(String type) async {
    database =
        await $FloorTodoDatabase.databaseBuilder('Todo_database.db').build();
    TodoDAO dao = database!.todoDAO;
    var result = await dao.findTodoByType(type);
    shoppingTodosCount = result.length;
    printLog('counter: $personalTodosCount');
    notifyListeners();
  }

  Future<dynamic> saveDateTime(String selectedDate) async {
    todoCreatedDateTime = selectedDate;
    printLog('todoCreatedDateTime: $todoCreatedDateTime');
    notifyListeners();
  }

  Future<void> changeWorkStatus(WorkType workType) async {
    currentWorkType = workType;
    printLog('Work type: $currentWorkType');
    notifyListeners();
  }

  Future<dynamic> addTodoItem() async {
    database =
        await $FloorTodoDatabase.databaseBuilder('Todo_database.db').build();
    TodoDAO dao = database!.todoDAO;
    String typeOfWork = validation.validateTaskType(currentWorkType);
    Todo todo = Todo(
        title: taskController.text.toString(),
        type: typeOfWork,
        date: todoCreatedDateTime.toString(),
        finished: false);
    notifyListeners();
    printLog(
        'Todo: ${todo.title}, ${todo.type}, ${todo.finished}, ${todo.date}');
    return await dao.insertTodo(todo);
  }

  FutureOr onGoBack(dynamic value) async {
    name = await readFromStorage(preference.name);
    imageUrl = await readFromStorage(preference.photoUrl);
    notifyListeners();
  }

  void navigateUserPage() {
    Route route =
        MaterialPageRoute(builder: (context) => const UserProfilePage());
    Navigator.push(App.ctx!, route).then(onGoBack);
  }
}
