import 'package:flutter/material.dart';
import 'package:flutter_todo_app/database/dao/task_dao.dart';
import 'package:flutter_todo_app/database/database.dart';
import 'package:flutter_todo_app/database/entity/task.dart';
import 'package:flutter_todo_app/utils/utilities.dart';

class AllTaskDetailsViewModel extends ChangeNotifier {
  bool isLoading = false;
  TodoDatabase? database;

  Future<List<Todo>> getAllTodos(String workType) async {
    database =
        await $FloorTodoDatabase.databaseBuilder('Todo_database.db').build();
    TodoDAO dao = database!.todoDAO;
    notifyListeners();
    return await dao.findTodoByType(workType);
  }

  Future<Todo?> updateTodo(bool finished, int id) async {
    bool completed = finished ? false : true;
    printLog('Id: $id Completed:- $completed');
    isLoading = true;
    database =
        await $FloorTodoDatabase.databaseBuilder('Todo_database.db').build();
    TodoDAO dao = database!.todoDAO;
    isLoading = false;
    notifyListeners();
    return await dao.updateTodo(completed, id);
  }
}
