class Employee {
  final int? id;
  final String name;
  final String gender;
  final String skill;

  Employee({
    this.id,
    required this.name,
    required this.gender,
    required this.skill,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'gender': gender, 'skill': skill};
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
      skill: map['skill'] ?? '',
    );
  }

  Employee copyWith({int? id, String? name, String? gender, String? skill}) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      skill: skill ?? this.skill,
    );
  }

  @override
  String toString() {
    return 'Employee{id: $id, name: $name, gender: $gender, skill: $skill}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Employee &&
        other.id == id &&
        other.name == name &&
        other.gender == gender &&
        other.skill == skill;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ gender.hashCode ^ skill.hashCode;
  }
}
