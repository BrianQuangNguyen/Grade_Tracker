import 'package:flutter/material.dart';
import 'package:grade_calculator/model/assignment.dart';

class Course {
  String id;
  String name;
  Color color;
  List <Assignment> assignments; 

  Course ({
    required this.id,
    required this.name,
    required this.color,
    List<Assignment>? assignments,
  }) : assignments = assignments ?? [];

  double get grade {
    int roundingVar = 100;
    if (assignments.isEmpty) return 0;

    double weightedSum = 0;
    double totalWeight = 0;

    for (var assignment in assignments) {
      weightedSum += assignment.grade * assignment.weight;
      totalWeight += assignment.weight;
    }
    return (weightedSum/totalWeight * roundingVar).round() / 100;
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'grade': grade,
      'color': color.value,
      'assignments': assignments.map((a) => a.toMap()).toList(),

    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      name: map['name'],
      color: Color(map['color']),
      assignments: (map['assignments'] as List<dynamic>)
          .map((a) => Assignment.fromMap(a))
          .toList(),
    );
  }
}
