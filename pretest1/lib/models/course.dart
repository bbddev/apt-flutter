class Course {
  int? id;
  String name;
  String duration;
  int fee;

  Course({
    this.id,
    required this.name,
    required this.duration,
    required this.fee,
  });

  // Convert Course to Map for database operations
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'duration': duration, 'fee': fee};
  }

  // Create Course from Map (from database)
  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      name: map['name'],
      duration: map['duration'],
      fee: map['fee'],
    );
  }

  @override
  String toString() {
    return 'Course{id: $id, name: $name, duration: $duration, fee: $fee}';
  }
}
