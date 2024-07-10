import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      is_completed INTEGER,
      due_date TEXT,
      created_at TEXT,
      updated_at TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE subtasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      task_id INTEGER,
      title TEXT,
      description TEXT,
      due_date TEXT,
      is_completed INTEGER,
      created_at TEXT,
      updated_at TEXT,
      FOREIGN KEY (task_id) REFERENCES tasks (id) ON DELETE CASCADE
    )
    ''');
  }

  Future<int> insertTask(Map<String, dynamic> task) async {
    Database db = await database;
    return await db.insert('tasks', task);
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    Database db = await database;
    return await db.query('tasks');
  }

  Future<int> updateTask(int id, Map<String, dynamic> task) async {
    Database db = await database;
    return await db.update('tasks', task, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTask(int id) async {
    Database db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertSubtask(Map<String, dynamic> subtask) async {
    Database db = await database;
    return await db.insert('subtasks', subtask);
  }

  Future<List<Map<String, dynamic>>> getSubtasks(int taskId) async {
    Database db = await database;
    return await db.query('subtasks', where: 'task_id = ?', whereArgs: [taskId]);
  }

  Future<int> updateSubtask(int id, Map<String, dynamic> subtask) async {
    Database db = await database;
    return await db.update('subtasks', subtask, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteSubtask(int id) async {
    Database db = await database;
    return await db.delete('subtasks', where: 'id = ?', whereArgs: [id]);
  }
}