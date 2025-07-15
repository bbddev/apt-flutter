import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'dart:io';

class SubjectDB {
  static Database? db;

  static Future<Database> get database async {
    if (db != null) {
      return db!;
    } else {
      db = await initDB();
      return db!;
    }
  }

  static Future<Database> initDB() async {
    String sql = "CREATE TABLE IF NOT EXISTS SubjectDB ("
        "id TEXT PRIMARY KEY, "
        "name TEXT, "
        "code TEXT, "
        "fee INTEGER"
        ")";
    final pathDB = await getDatabasesPath();
    final path = await join(pathDB, "SubjectDB.db");
    db = await openDatabase(
        path, version: 1, onCreate: (Database db, int version) async {
      //thuc thi, tao database
      await db.execute(sql);
      print("SubjectDB created");
      //chen du lieu mau
      await db.execute(
          "INSERT INTO SubjectDB (id, name, code, fee) VALUES "
              "('CS101', 'Computer Science', 'CS101', 5000),"
              "('MATH101', 'Calculus', 'MATH101', 3000),"
              "('PHY101', 'Physics', 'PHY101', 4000)");
      print("Sample data inserted into SubjectDB");
    });
    return db!;
  }
}