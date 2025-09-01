class Assignment {
  String id;
  String name;
  int mark;
  int maxMark;
  double grade;
  int weight;

  Assignment ({
    required this.id,
    required this.name,
    required this.mark,
    required this.maxMark,
    required this.weight,
  }) : grade = (mark/maxMark * 10000).round() / 100;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mark': mark,
      'maxMark': maxMark,
      'grade': grade,
      'weight':weight
    };
  }

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'],
      name: map['name'],
      mark: map['mark'],
      maxMark: map['maxMark'],
      weight: map['weight'],
    );
  }
}