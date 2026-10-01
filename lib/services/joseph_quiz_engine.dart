class JosephQuizEngine {
  const JosephQuizEngine();

  List<Map<String, dynamic>> generate(String topic) {
    final t = topic.toLowerCase();

    if (t.contains("anova")) {
      return [
        {
          "question": "What is the main purpose of ANOVA?",
          "options": [
            "Compare means",
            "Compare proportions",
            "Measure correlation",
            "Predict values"
          ],
          "answer": 0
        },
        {
          "question": "ANOVA is commonly used when comparing:",
          "options": [
            "2 groups",
            "3 or more groups",
            "Percentages",
            "Probabilities"
          ],
          "answer": 1
        },
      ];
    }

    if (t.contains("python")) {
      return [
        {
          "question": "Python is mainly a:",
          "options": [
            "Database",
            "Programming language",
            "Web browser",
            "Compiler"
          ],
          "answer": 1
        }
      ];
    }

    return [
      {
        "question": "No quiz available yet for $topic.",
        "options": ["OK"],
        "answer": 0
      }
    ];
  }
}