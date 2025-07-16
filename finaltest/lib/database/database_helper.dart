import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/employee.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'employee_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE employees (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        gender TEXT NOT NULL,
        skill TEXT NOT NULL
      )
    ''');

    // Insert some sample data
    await db.insert('employees', {
      'name': 'John Doe',
      'gender': 'Male',
      'skill': 'Flutter Developer',
    });
    await db.insert('employees', {
      'name': 'Jane Smith',
      'gender': 'Female',
      'skill': 'UI/UX Designer',
    });
    await db.insert('employees', {
      'name': 'Mike Johnson',
      'gender': 'Male',
      'skill': 'Backend Developer',
    });
    await db.insert('employees', {
      'name': 'Sarah Wilson',
      'gender': 'Female',
      'skill': 'Project Manager',
    });
    await db.insert('employees', {
      'name': 'David Brown',
      'gender': 'Male',
      'skill': 'DevOps Engineer',
    });
  }

  Future<int> insertEmployee(Employee employee) async {
    final db = await database;
    return await db.insert('employees', employee.toMap());
  }

  Future<List<Employee>> getAllEmployees() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('employees');
    return List.generate(maps.length, (i) {
      return Employee.fromMap(maps[i]);
    });
  }

  Future<List<Employee>> searchEmployees(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'employees',
      where: 'name LIKE ? OR gender LIKE ? OR skill LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) {
      return Employee.fromMap(maps[i]);
    });
  }

  Future<int> updateEmployee(Employee employee) async {
    final db = await database;
    return await db.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<int> deleteEmployee(int id) async {
    final db = await database;
    return await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
