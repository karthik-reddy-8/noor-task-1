import 'package:flutter/material.dart';
import 'package:flutter_todo_app/database/database.dart';
import 'package:flutter_todo_app/database/entity/task.dart';
import 'package:flutter_todo_app/utils/utilities.dart';

class AllTaskDetailsViewModel extends ChangeNotifier{
  bool isLoading = false;
  late TodoDatabase database;

  Future<List<Todo>> getAllTodos(String workType) async {
    $FloorTodoDatabase
        .databaseBuilder('Todo_database.db')
        .build()
        .then((value) async {
      database = value;
      notifyListeners();
    });
    return await database.todoDAO.findTodoByType(workType);
  }

  Future<List<Todo>> getCompletedTodos(bool status, String type) async {
    isLoading = true;
    $FloorTodoDatabase
        .databaseBuilder('Todo_database.db')
        .build()
        .then((value) async {
      database = value;
      isLoading = false;
      notifyListeners();
    });
    return await database.todoDAO.findTodoByStatus(status, type);
  }

  Future<Todo?> updateTodo(bool finished, int id) async {
    bool completed = finished ? false : true;
    printLog('Id: $id Completed:- $completed');
    isLoading = true;
    $FloorTodoDatabase
        .databaseBuilder('Todo_database.db')
        .build()
        .then((value) async {
      database = value;
      notifyListeners();
    });
    isLoading = false;
    notifyListeners();
    return await database.todoDAO.updateTodo(completed, id);
  }
}