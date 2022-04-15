// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorTodoDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$TodoDatabaseBuilder databaseBuilder(String name) =>
      _$TodoDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$TodoDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$TodoDatabaseBuilder(null);
}

class _$TodoDatabaseBuilder {
  _$TodoDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$TodoDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$TodoDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<TodoDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$TodoDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$TodoDatabase extends TodoDatabase {
  _$TodoDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TodoDAO? _todoDAOInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Todo` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `type` TEXT NOT NULL, `date` TEXT NOT NULL, `finished` INTEGER NOT NULL, `email` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TodoDAO get todoDAO {
    return _todoDAOInstance ??= _$TodoDAO(database, changeListener);
  }
}

class _$TodoDAO extends TodoDAO {
  _$TodoDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _todoInsertionAdapter = InsertionAdapter(
            database,
            'Todo',
            (Todo item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'type': item.type,
                  'date': item.date,
                  'finished': item.finished ? 1 : 0,
                  'email': item.email
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Todo> _todoInsertionAdapter;

  @override
  Future<List<Todo>> findAllTodos() async {
    return _queryAdapter.queryList('SELECT * FROM Todo',
        mapper: (Map<String, Object?> row) => Todo(
            id: row['id'] as int?,
            title: row['title'] as String,
            type: row['type'] as String,
            date: row['date'] as String,
            finished: (row['finished'] as int) != 0,
            email: row['email'] as String?));
  }

  @override
  Future<List<Todo>> findTodoByType(String type) async {
    return _queryAdapter.queryList('SELECT * FROM Todo WHERE type = ?1',
        mapper: (Map<String, Object?> row) => Todo(
            id: row['id'] as int?,
            title: row['title'] as String,
            type: row['type'] as String,
            date: row['date'] as String,
            finished: (row['finished'] as int) != 0,
            email: row['email'] as String?),
        arguments: [type]);
  }

  @override
  Future<int?> getTodoCountByType(String type) async {
    await _queryAdapter.queryNoReturn(
        'SELECT COUNT (*) FROM Todo WHERE type =?1',
        arguments: [type]);
  }

  @override
  Future<List<Todo>> findTodoByStatus(bool status, String type) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Todo WHERE (finished = ?1 AND type =?2 )',
        mapper: (Map<String, Object?> row) => Todo(
            id: row['id'] as int?,
            title: row['title'] as String,
            type: row['type'] as String,
            date: row['date'] as String,
            finished: (row['finished'] as int) != 0,
            email: row['email'] as String?),
        arguments: [status ? 1 : 0, type]);
  }

  @override
  Future<List<Todo>> findTodoByDate(String dateTime) async {
    return _queryAdapter.queryList('SELECT * FROM Todo WHERE date = ?1',
        mapper: (Map<String, Object?> row) => Todo(
            id: row['id'] as int?,
            title: row['title'] as String,
            type: row['type'] as String,
            date: row['date'] as String,
            finished: (row['finished'] as int) != 0,
            email: row['email'] as String?),
        arguments: [dateTime]);
  }

  @override
  Future<Todo?> updateTodo(bool finished, int id) async {
    return _queryAdapter.query('UPDATE Todo SET finished=?1 WHERE id = ?2',
        mapper: (Map<String, Object?> row) => Todo(
            id: row['id'] as int?,
            title: row['title'] as String,
            type: row['type'] as String,
            date: row['date'] as String,
            finished: (row['finished'] as int) != 0,
            email: row['email'] as String?),
        arguments: [finished ? 1 : 0, id]);
  }

  @override
  Future<Todo?> deleteTodo(int id) async {
    return _queryAdapter.query('DELETE FROM Todo WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Todo(
            id: row['id'] as int?,
            title: row['title'] as String,
            type: row['type'] as String,
            date: row['date'] as String,
            finished: (row['finished'] as int) != 0,
            email: row['email'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> insertTodo(Todo todo) async {
    await _todoInsertionAdapter.insert(todo, OnConflictStrategy.abort);
  }
}
