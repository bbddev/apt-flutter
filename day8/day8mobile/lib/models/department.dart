class Department {
  num? id;
  String? name;

  Department({this.id, this.name});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    return map;
  }

  Department.fromJson(dynamic json){
    id = json["id"];
    name = json["name"];
  }
}