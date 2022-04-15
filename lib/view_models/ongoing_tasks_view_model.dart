import 'package:flutter/material.dart';
import 'package:flutter_todo_app/database/database.dart';
import 'package:flutter_todo_app/database/entity/task.dart';

class OngoingTasksViewModel extends ChangeNotifier{
  bool isLoading = false;
  TodoDatabase? database;

  Future<List<Todo>> getOngoingTodos(bool status, String type) async {
    isLoading = true;
    $FloorTodoDatabase
        .databaseBuilder('Todo_database.db')
        .build()
        .then((value) async {
      database = value;
      isLoading = false;
      notifyListeners();
    });
    return await database!.todoDAO.findTodoByStatus(status, type);
  }

  Future<Todo?> updateTodo(bool finished, int id) async {
    bool completed = finished ? false : true;
    isLoading = true;
    notifyListeners();
    $FloorTodoDatabase
        .databaseBuilder('Todo_database.db')
        .build()
        .then((value) async {
      database = value;
    });
    isLoading = false;
    notifyListeners();
    return await database!.todoDAO.updateTodo(completed, id);
  }
}