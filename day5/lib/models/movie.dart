class Movie {
  num? id;
  String? name;
  String? year;
  bool? isFavorite;

  Movie({this.id, this.name, this.year, this.isFavorite});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["year"] = year;
    map["isFavorite"] = isFavorite! ? 1 : 0;
    return map;
  }

  Movie.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    year = json["year"];
    isFavorite = json["isFavorite"] == 1;
  }
}
