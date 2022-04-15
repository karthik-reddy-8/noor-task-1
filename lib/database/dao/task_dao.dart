import 'package:floor/floor.dart';
import 'package:flutter_todo_app/database/entity/task.dart';

@dao
abstract class TodoDAO {
  @Query('SELECT * FROM Todo')
  Future<List<Todo>> findAllTodos();

  @Query('SELECT * FROM Todo WHERE type = :type')
  Future<List<Todo>> findTodoByType(String type);
  
  @Query('SELECT COUNT (*) FROM Todo WHERE type =:type')
  Future<int?> getTodoCountByType(String type);

  @Query('SELECT * FROM Todo WHERE (finished = :status AND type =:type )')
  Future<List<Todo>> findTodoByStatus(bool status,String type);

  @Query('SELECT * FROM Todo WHERE date = :dateTime')
  Future<List<Todo>> findTodoByDate(String dateTime);

  @insert
  Future<void> insertTodo(Todo todo);

  @Query("UPDATE Todo SET finished=:finished WHERE id = :id")
  Future<Todo?> updateTodo(bool finished, int id);

  @Query('DELETE FROM Todo WHERE id = :id')
  Future<Todo?> deleteTodo(int id);
}