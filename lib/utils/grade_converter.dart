double convertFourPoint(double grade) {
  final table = [
    {'min' : 90.0, 'gpa' : 4.0},
    {'min' : 85.0, 'gpa' : 3.9},
    {'min' : 80.0, 'gpa' : 3.7},
    {'min' : 77.0, 'gpa' : 3.3},
    {'min' : 73.0, 'gpa' : 3.0},
    {'min' : 70.0, 'gpa' : 2.7},
    {'min' : 67.0, 'gpa' : 2.3},
    {'min' : 63.0, 'gpa' : 2.0},
    {'min' : 60.0, 'gpa' : 1.7},
    {'min' : 57.0, 'gpa' : 1.3},
    {'min' : 53.0, 'gpa' : 1.0},
    {'min' : 50.0, 'gpa' : 0.7},
    {'min' : 0.0, 'gpa' : 0.0},
  ];

  for (final entry in table) {
    if (grade >= entry['min']!) return entry['gpa']!;
  }
  return 0.0;
}

int convertTwelvePoint(double grade) {
  final table = [
    {'min' : 90, 'gpa' : 12},
    {'min' : 85, 'gpa' : 11},
    {'min' : 80, 'gpa' : 10},
    {'min' : 77, 'gpa' : 9},
    {'min' : 73, 'gpa' : 8},
    {'min' : 70, 'gpa' : 7},
    {'min' : 67, 'gpa' : 6},
    {'min' : 63, 'gpa' : 5},
    {'min' : 60, 'gpa' : 4},
    {'min' : 57, 'gpa' : 3},
    {'min' : 53, 'gpa' : 2},
    {'min' : 50, 'gpa' : 1},
    {'min' : 0, 'gpa' : 0},
  ];

  for (final entry in table) {
    if (grade >= entry['min']!) return entry['gpa']!;
  }
  return 0;
}