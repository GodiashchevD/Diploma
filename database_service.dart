import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');

    _db = await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            text TEXT,
            date TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE tests (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            questions TEXT,
            answers TEXT,
            score INTEGER,
            date TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 4) {
          await db.execute('ALTER TABLE tests ADD COLUMN score INTEGER');
        }
      },
    );

    return _db!;
  }

  static Future<void> insertNote(String text) async {
    final db = await database;

    await db.insert('notes', {
      'title': 'Новый конспект',
      'text': text,
      'date': DateTime.now().toString(),
    });
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    return await db.query('notes', orderBy: 'id DESC');
  }

  static Future<void> updateNote(int id, String title, String text) async {
    final db = await database;

    await db.update(
      'notes',
      {'title': title, 'text': text},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> insertTest(
      String title, List questions, List answers, int score) async {
    final db = await database;

    await db.insert('tests', {
      'title': title.isEmpty ? "Новый тест" : title,
      'questions': jsonEncode(questions),
      'answers': jsonEncode(answers),
      'score': score,
      'date': DateTime.now().toString(),
    });
  }

  static Future<List<Map<String, dynamic>>> getTests() async {
    final db = await database;
    return await db.query('tests', orderBy: 'id DESC');
  }

  static Future<void> deleteTest(int id) async {
    final db = await database;
    await db.delete('tests', where: 'id = ?', whereArgs: [id]);
  }
  static Future<void> updateTest(
    int id, List answers, int score) async {

  final db = await database;

  await db.update(
    'tests',
    {
      'answers': jsonEncode(answers),
      'score': score,
      'date': DateTime.now().toString(),
    },
    where: 'id = ?',
    whereArgs: [id],
  );
}
}