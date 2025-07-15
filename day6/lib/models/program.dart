class Program {
  num? id;
  String? name;
  num? rate;

  Program({this.id, this.name, this.rate});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["rate"] = rate;
    return map;
  }

  Program.fromJson(dynamic json){
    id = json["id"];
    name = json["name"];
    rate = json["rate"];
  }
}