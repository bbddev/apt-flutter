class Contact {
  int? id;
  String? name;
  String? phone;

  Contact({this.id, this.name, this.phone});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["phone"] = phone;
    return map;
  }

  Contact.fromJson(dynamic json){
    id = json["id"];
    name = json["name"];
    phone = json["phone"];
  }
}