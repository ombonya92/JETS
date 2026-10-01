class StudentProfile {
  final String name;
  final String university;
  final String course;
  final int year;
  final int semester;

  final List<String> units;

  const StudentProfile({
    required this.name,
    required this.university,
    required this.course,
    required this.year,
    required this.semester,
    required this.units,
  });
}