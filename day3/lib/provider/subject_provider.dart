import 'package:day3/db/SubjectDB.dart';
import 'package:day3/models/subject.dart';
import 'package:flutter/material.dart';

class SubjectProvider with ChangeNotifier {
  List<Subject> allSubjects = [];
  Subject? _subject;

  Future getSubjects() async {
    final db = await SubjectDB.database;
    final subjects = await db.query("SubjectDB");
    allSubjects = subjects.map((e) => Subject.fromJson(e)).toList();
    notifyListeners();
  }

  Future searchByName(String name) async {
    final db = await SubjectDB.database;
    final subjects = await db.rawQuery(
      "SELECT * FROM SubjectDB WHERE name LIKE '%$name%'",
    );
    allSubjects = subjects.map((e) => Subject.fromJson(e)).toList();
    notifyListeners();
  }

  Future saveSubject(Subject newSubject) async {
    final db = await SubjectDB.database;
    await db.insert("SubjectDB", newSubject.toJson());
    allSubjects.add(newSubject);
    notifyListeners();
  }

  Future deleteSubject(String code) async {
    final db = await SubjectDB.database;
    await db.delete("SubjectDB", where: "code = ?", whereArgs: [code]);
    allSubjects.removeWhere((subject) => subject.code == code);
    notifyListeners();
  }

  Future<Subject> getSubjectByCode(String code) async {
    final db = await SubjectDB.database;
    final result = await db.query(
      "SubjectDB",
      where: "code = ?",
      whereArgs: [code],
    );
    return _subject = Subject.fromJson(result.first);
  }

  Future updateSubject(Subject subject) async {
    final db = await SubjectDB.database;
    await db.update(
      "SubjectDB",
      subject.toJson(),
      where: "code = ?",
      whereArgs: [subject.code],
    );
    final index = allSubjects.indexWhere((p) => p.code == subject.code);
    allSubjects[index] = subject;
    notifyListeners();
  }

  Future<void> deleteAllSubjects() async {
    final db = await SubjectDB.database;
    await db.delete("SubjectDB");
  }
}

// import 'package:day3/db/SubjectDB.dart';
// import 'package:day3/models/subject.dart';
//
// class SubjectService {
//   static Future<List<Subject>> getSubjects() async {
//     final db = await SubjectDB.database;
//     final subjects = await db.query("SubjectDB");
//     return subjects.map((e) => Subject.fromJson(e)).toList();
//   }
//
//   static Future<List<Subject>> searchByName(String name) async {
//     final db = await SubjectDB.database;
//     final subjects = await db.rawQuery("SELECT * FROM SubjectDB WHERE name LIKE '%$name%'");
//     return subjects.map((e) => Subject.fromJson(e)).toList();
//   }
//
//   static Future<int> saveSubject(Subject newSubject) async {
//     final db = await SubjectDB.database;
//     return await db.insert("SubjectDB", newSubject.toJson());
//   }
//   static Future<int> deleteSubject(String code) async {
//     final db = await SubjectDB.database;
//     return await db.delete("SubjectDB", where: "code = ?", whereArgs: [code]);
//   }
//
//   static Future<Subject?> getSubjectByCode(String code) async {
//     final db = await SubjectDB.database;
//     final result = await db.query(
//       "SubjectDB",
//       where: "code = ?",
//       whereArgs: [code],
//     );
//     if (result.isNotEmpty) {
//       return Subject.fromJson(result.first);
//     }
//     return null;
//   }
//
//   static Future<int> updateSubject(Subject subject) async {
//     final db = await SubjectDB.database;
//     return await db.update(
//       "SubjectDB",
//       subject.toJson(),
//       where: "code = ?",
//       whereArgs: [subject.code],
//     );
//   }
//
//   static Future<void> deleteAllSubjects() async {
//     final db = await SubjectDB.database;
//     await db.delete("SubjectDB");
//   }
// }
