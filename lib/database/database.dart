import 'dart:async';

import 'package:floor/floor.dart';
import 'package:flutter_todo_app/database/dao/task_dao.dart';
import 'package:flutter_todo_app/database/entity/task.dart';
import 'package:sqflite/sqflite.dart' as sqflite;


part 'database.g.dart';

@Database(version: 1, entities: [Todo])
abstract class TodoDatabase extends FloorDatabase {
  TodoDAO get todoDAO;
}
