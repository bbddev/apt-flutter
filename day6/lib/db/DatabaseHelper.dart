import 'package:day6/models/program.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? db;
  Future<Database> get database async {
    db ??= await initDB();
    return db!;
  }

  Future<Database> initDB() async {
    // Define the path to the database
    String path = await getDatabasesPath();
    String dbPath = join(path, 'programs.db');

    // Open the database
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create tables here
        await db.execute('''
          CREATE TABLE program (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            rate INTEGER DEFAULT 0.0
          )
        ''');
        await db.execute(
          'INSERT INTO program (name, rate) VALUES ("Program 1", 10)',
        );
        await db.execute(
          'INSERT INTO program (name, rate) VALUES ("Program 2", 20)',
        );
        await db.execute(
          'INSERT INTO program (name, rate) VALUES ("Program 3", 30)',
        );
      },
    );
  }

  Future<List<Program>> getPrograms() async {
    final db = await database;
    final data = await db.query('program');
    return data.map((e) => Program.fromJson(e)).toList();
  }
  Future<int> insertProgram(Program program) async {
    final db = await database;
    return await db.insert('program', program.toJson());
  }
  Future<int> updateProgram(Program program) async {
    final db = await database;
    return await db.update(
      'program',
      program.toJson(),
      where: 'id = ?',
      whereArgs: [program.id],
    );
  }
  Future<int> deleteProgram(int id) async {
    final db = await database;
    return await db.delete(
      'program',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
