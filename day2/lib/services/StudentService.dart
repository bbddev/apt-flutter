import 'package:day2/models/Student.dart';

class StudentService {
  static List<Student> _students = [
    Student(1, 'Andy', '09012345678'),
    Student(2, 'Betty', '09123456789'),
    Student(3, 'Charlie', '09234567890'),
    Student(4, 'David', '09345678901'),
    Student(5, 'Eva', '09456789012'),
    Student(6, 'Frank', '09567890123'),
    Student(7, 'Grace', '09678901234'),
    Student(8, 'Hannah', '09789012345'),
    Student(9, 'Ian', '09890123456'),
    Student(10, 'Jack', '09901234567'),

  ];

  static List<Student> getStudents() {
    return _students;
  }

  static void saveStudent(Student newStudent) {
    _students.add(newStudent);
  }

  static void deleteStudent(int id) {
    _students.removeWhere((student) => student.id == id);
  }
}