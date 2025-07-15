import 'dart:convert';
import 'package:day8mobile/models/department.dart';
import 'package:http/http.dart' as http;
import 'package:day8mobile/models/employee.dart';

class ApiService{
  static const String url = "http://172.16.1.144:9999/api";
  static const String urlDep = '$url/department';
  static const String urlEmp = '$url/employee';

  Future<List<Employee>> getAllEmployees() async {
    final response = await http.get(Uri.parse(urlEmp));
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      List<Employee> employees = [];
      for (var item in data) {
        employees.add(Employee.fromJson(item));
      }
      return employees;
    } else {
      throw Exception('Failed to load employees');
    }
  }
  Future<List<Department>> getAllDepartment() async {
    final response = await http.get(Uri.parse(urlDep));
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      List<Department> departments = [];
      for (var item in data) {
        departments.add(Department.fromJson(item));
      }
      return departments;
    } else {
      throw Exception('Failed to load departments');
    }
  }

  Future<Employee> createEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse(urlEmp),
      headers: <String,String>{"Content-Type": "application/json"},
      body: json.encode(employee.toJson()),
    );
    if (response.statusCode == 201) {
      return Employee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create employee');
    }
  }

  Future<void> deleteEmployee(String code) async {
    final response = await http.delete(Uri.parse('$urlEmp/$code'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete employee');
    }
  }
  Future<Employee> checkLogin(String code, String password) async {
    final response = await http.post(
      Uri.parse('$url/login'),
      headers: <String,String>{"Content-Type": "application/json"},
      body: json.encode({"code": code, "password": password}),
    );
    if (response.statusCode == 200) {
      return Employee.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Invalid credentials');
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<bool> checkEmployeeCodeExists(String code) async {
    final response = await http.get(Uri.parse('$urlEmp/$code'));
    if (response.statusCode == 200) {
      return true; // Employee exists
    } else if (response.statusCode == 404) {
      return false; // Employee does not exist
    } else {
      throw Exception('Failed to check employee existence');
    }
  }

}