import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/preferences.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/database/database.dart';
import 'package:flutter_todo_app/database/entity/task.dart';
import 'package:flutter_todo_app/enums/work_type.dart';
import 'package:flutter_todo_app/services/model/response/user_data_response_model.dart';
import 'package:flutter_todo_app/utils/custom_widgets.dart';
import 'package:flutter_todo_app/utils/preference_helper.dart';
import 'package:flutter_todo_app/utils/utilities.dart';
import 'package:flutter_todo_app/views/dashboard_page.dart';
import 'package:flutter_todo_app/widgets/commons/validations.dart';
import 'package:stacked/stacked.dart';

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
  UserDataResponseModel responseModel = UserDataResponseModel();

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
      final counter = await database?.todoDAO.getTodoCountByType('Personal');
      notifyListeners();
      printLog('counter: ${counter.toString()}');
      return counter;
    });
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
      if (selectedDate.day.toString() == DateTime.now().day.toString()) {
        selectedDateTime = 'Today';
        printLog('selectedDateTime: $selectedDateTime');
      } else {
        return;
      }
    }
    notifyListeners();
  }

  // Future<dynamic> getUserData() async{
  //  printLog('User Id:- ${auth.currentUser?.uid}');
  //  dbRefer.child('Users').orderByKey()
  //      .equalTo(auth.currentUser?.uid)
  //      .once()
  //      .then((event) {
  //   dynamic response = event.snapshot.value;
  //   printLog('User data:- $response');
  //   userList.clear();
  //   response.forEach((key, value){
  //    UserDataResponseModel responseModel = UserDataResponseModel(
  //     photoUrl: value['photoUrl'],
  //     phone: value['phone'],
  //     password: value['password'],
  //     email: value['email'],
  //     name: value['name']
  //    );
  //    userList.add(responseModel);
  //   });
  //   notifyListeners();
  //  }).catchError((onError) {
  //   printLog(onError);
  //    // showSnack(message: onError);
  //  });
  // }

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

  Future<List<Todo>?> getAllTodos(String workType) async {
    $FloorTodoDatabase
        .databaseBuilder('Todo_database.db')
        .build()
        .then((value) async {
      database = value;
      notifyListeners();
    });
    return await database?.todoDAO.findTodoByType(workType);
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
