import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static Database? db;

  static Future<Database> get database async {
    if (db != null) {
      return db!;
    } else {
      db = await initDatabase();
      return db!;
    }
  }

  static Future<Database> initDatabase() async {
    final getDirectory = await getApplicationDocumentsDirectory();
    String path = "${getDirectory.path}EmployeeDB.db";

    return openDatabase(path, onCreate: onCreate, version: 1);
  }

  static void onCreate(Database db, int version) async {
    String query =
        'CREATE TABLE Employee(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, level INTEGER, salary INTEGER)';
    String insert = 'INSERT INTO Employee(name, level, salary) VALUES("Alex", 3, 4000)';
    String insert2 = 'INSERT INTO Employee(name, level, salary) VALUES("Bob", 5, 5000)';
    String insert3 = 'INSERT INTO Employee(name, level, salary) VALUES("Charlie", 4, 3000)';
    String insert4 = 'INSERT INTO Employee(name, level, salary) VALUES("David", 3, 4500)';
    String insert5 = 'INSERT INTO Employee(name, level, salary) VALUES("Eve", 5, 5500)';
    String insert6 = 'INSERT INTO Employee(name, level, salary) VALUES("Frank", 4, 3500)';
    await db.execute(query);
    await db.execute(insert);
    await db.execute(insert2);
    await db.execute(insert3);
    await db.execute(insert4);
    await db.execute(insert5);
    await db.execute(insert6);
  }
}
