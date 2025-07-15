class Employee {
  int? id;
  String? name;
  int? level;
  int? salary;

  Employee({this.id, this.name, this.level, this.salary});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["level"] = level;
    map["salary"] = salary;
    return map;
  }

  Employee.fromJson(dynamic json){
    id = json["id"];
    name = json["name"];
    level = json["level"];
    salary = json["salary"];
  }
}