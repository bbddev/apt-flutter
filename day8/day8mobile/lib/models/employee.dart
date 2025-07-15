import 'package:day8mobile/models/department.dart';

class Employee {
  String? code;
  String? name;
  String? password;
  num? gender;
  Department? department;

  Employee({this.code, this.name, this.password, this.gender, this.department});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["code"] = code;
    map["name"] = name;
    map["password"] = password;
    map["gender"] = gender;
    if (department != null) {
      map["department"] = department?.toJson();
    }
    return map;
  }

  Employee.fromJson(dynamic json){
    code = json["code"];
    name = json["name"];
    password = json["password"];
    gender = json["gender"];
    department =
    json["department"] != null ? Department.fromJson(json["department"]) : null;
  }
}