class AcademicDomain {
  final String name;

  final List<String> subjects;

  const AcademicDomain({
    required this.name,
    required this.subjects,
  });
}

class AcademicDomains {
  static const List<AcademicDomain> domains = [

    AcademicDomain(
      name: "Medicine",
      subjects: [
        "Anatomy",
        "Physiology",
        "Biochemistry",
        "Pathology",
        "Pharmacology",
        "Microbiology",
        "Public Health",
        "Epidemiology",
        "Nursing",
      ],
    ),

    AcademicDomain(
      name: "Engineering",
      subjects: [
        "Mechanics",
        "Thermodynamics",
        "Electronics",
        "Civil Engineering",
        "Electrical Engineering",
        "Mechanical Engineering",
      ],
    ),

    AcademicDomain(
      name: "Computer Science",
      subjects: [
        "Programming",
        "Algorithms",
        "Networking",
        "Database",
        "Cyber Security",
        "Artificial Intelligence",
        "Software Engineering",
      ],
    ),

    AcademicDomain(
      name: "Business",
      subjects: [
        "Accounting",
        "Economics",
        "Finance",
        "Marketing",
        "Management",
      ],
    ),

    AcademicDomain(
      name: "Law",
      subjects: [
        "Constitutional Law",
        "Criminal Law",
        "Civil Law",
        "Commercial Law",
      ],
    ),

    AcademicDomain(
      name: "Education",
      subjects: [
        "Curriculum",
        "Teaching Practice",
        "Educational Psychology",
      ],
    ),

    AcademicDomain(
      name: "Agriculture",
      subjects: [
        "Crop Science",
        "Animal Science",
        "Agribusiness",
      ],
    ),

    AcademicDomain(
      name: "Pure Sciences",
      subjects: [
        "Physics",
        "Chemistry",
        "Biology",
        "Mathematics",
        "Statistics",
      ],
    ),
  ];
}