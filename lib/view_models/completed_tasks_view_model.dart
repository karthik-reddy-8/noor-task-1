import 'package:flutter/material.dart';
import 'package:flutter_todo_app/database/dao/task_dao.dart';
import 'package:flutter_todo_app/database/database.dart';
import 'package:flutter_todo_app/database/entity/task.dart';

class CompletedTaskViewModel extends ChangeNotifier {
  bool isLoading = false;
  TodoDatabase? database;

  Future<List<Todo>> getCompletedTodos(bool status, String type) async {
    isLoading = true;
    database =
        await $FloorTodoDatabase.databaseBuilder('Todo_database.db').build();
    TodoDAO dao = database!.todoDAO;
    isLoading = false;
    notifyListeners();
    return await dao.findTodoByStatus(status, type);
  }

  Future<Todo?> updateTodo(bool finished, int id) async {
    bool completed = finished ? false : true;
    isLoading = true;
    database =
        await $FloorTodoDatabase.databaseBuilder('Todo_database.db').build();
    TodoDAO dao = database!.todoDAO;
    isLoading = false;
    notifyListeners();
    return await dao.updateTodo(completed, id);
  }
}
