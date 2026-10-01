 class AcademicKnowledgeEngine {
  AcademicKnowledgeEngine();

  final Map<String, String> _knowledge = {
    // Mathematics
    "quadratic":
        "A quadratic equation is an equation of degree two written as ax² + bx + c = 0.",
    "derivative":
        "A derivative measures the rate of change of a function with respect to a variable.",
    "integration":
        "Integration is the reverse of differentiation and is used to calculate area under curves.",
    "pythagoras":
        "Pythagoras theorem states that a² + b² = c² for a right-angled triangle.",

    // Statistics
    "anova":
        "ANOVA (Analysis of Variance) compares the means of three or more groups.",
    "regression":
        "Regression determines relationships between dependent and independent variables.",
    "correlation":
        "Correlation measures the strength and direction of association between variables.",
    "chi-square":
        "Chi-square tests relationships between categorical variables.",
    "t-test":
        "A t-test compares the means of two groups.",
    "probability":
        "Probability measures the likelihood of an event occurring.",

    // Biology
    "photosynthesis":
        "Photosynthesis converts sunlight into chemical energy using chlorophyll.",
    "cell":
        "The cell is the basic structural and functional unit of life.",
    "mitosis":
        "Mitosis produces two genetically identical daughter cells.",

    // Chemistry
    "atom":
        "An atom is the smallest unit of an element.",
    "acid":
        "An acid donates hydrogen ions (H+).",
    "base":
        "A base accepts hydrogen ions or releases hydroxide ions.",

    // Physics
    "newton":
        "Newton's Laws describe motion, force and inertia.",
    "velocity":
        "Velocity is speed in a specified direction.",
    "force":
        "Force is any push or pull that changes motion.",

    // Programming
    "python":
        "Python is a high-level programming language used in AI, web, automation and data science.",
    "flutter":
        "Flutter is Google's framework for building Android, iOS, Web and Desktop apps.",
    "algorithm":
        "An algorithm is a sequence of steps used to solve a problem.",
    "loop":
        "A loop repeats instructions until a condition changes.",

    // Public Health
    "epidemiology":
        "Epidemiology studies the distribution and determinants of diseases in populations.",
    "incidence":
        "Incidence is the number of new disease cases during a specified period.",
    "prevalence":
        "Prevalence is the total number of existing disease cases in a population.",
    "screening":
        "Screening identifies disease before symptoms appear."
  };

  String? answer(String question) {
    final q = question.toLowerCase();

    for (final item in _knowledge.entries) {
      if (q.contains(item.key)) {
        return item.value;
      }
    }

    return null;
  }
}