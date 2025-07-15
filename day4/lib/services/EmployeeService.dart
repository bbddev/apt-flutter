import 'package:day4/models/employee.dart';

import '../db/DatabaseHelper.dart';

class EmployeeService {
  static Future<List<Employee>> getEmployees() async {
    String sql = "SELECT * FROM Employee";
    final db = await DatabaseHelper.database;
    var data = await db.rawQuery(sql);
    var employees = List<Employee>.generate(
      data.length,
      (index) => Employee.fromJson(data[index]),
    );
    return employees;
  }

  static Future<List<Employee>> filterBySalary(int minSalary, int maxSalary) async {
    String sql = "SELECT * FROM Employee WHERE salary BETWEEN ? AND ?";
    final db = await DatabaseHelper.database;
    var data = await db.rawQuery(sql, [minSalary, maxSalary]);
    var employees = List<Employee>.generate(
      data.length,
      (index) => Employee.fromJson(data[index]),
    );
    return employees;
  }

  static Future<void> addEmployee(Employee employee) async {
    String sql = "INSERT INTO Employee(name, level, salary) VALUES(?, ?, ?)";
    final db = await DatabaseHelper.database;
    await db.rawInsert(sql, [employee.name, employee.level, employee.salary]);
  }

  static Future<void> deleteEmployee(int id) async {
    String sql = "DELETE FROM Employee WHERE id = ?";
    final db = await DatabaseHelper.database;
    await db.rawDelete(sql, [id]);
  }
}
