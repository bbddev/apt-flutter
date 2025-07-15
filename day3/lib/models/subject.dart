class Subject {
  String? code;
  String? name;
  num? fee;

  Subject({this.code, this.name, this.fee});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["code"] = code;
    map["name"] = name;
    map["fee"] = fee;
    return map;
  }

  Subject.fromJson(dynamic json){
    code = json["code"];
    name = json["name"];
    fee = json["fee"];
  }
}