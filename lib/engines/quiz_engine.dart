class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final String difficulty;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.difficulty,
  });
}

class QuizEngine {
  final List<QuizQuestion> _questionBank = [

    QuizQuestion(
      question: "What is Epidemiology?",
      options: [
        "Study of diseases in populations",
        "Study of computers",
        "Study of economics",
        "Study of engineering"
      ],
      correctAnswer: 0,
      explanation:
          "Epidemiology is the study of the distribution and determinants of diseases in populations.",
      difficulty: "Easy",
    ),

    QuizQuestion(
      question: "Which measure compares disease occurrence between two groups?",
      options: [
        "Mean",
        "Relative Risk",
        "Median",
        "Mode"
      ],
      correctAnswer: 1,
      explanation:
          "Relative Risk compares the probability of disease between exposed and unexposed groups.",
      difficulty: "Medium",
    ),

    QuizQuestion(
      question: "Which statistical test compares the means of more than two groups?",
      options: [
        "Chi-square",
        "t-test",
        "ANOVA",
        "Correlation"
      ],
      correctAnswer: 2,
      explanation:
          "ANOVA (Analysis of Variance) compares the means of three or more groups.",
      difficulty: "Medium",
    ),

    QuizQuestion(
      question: "What does a p-value less than 0.05 usually indicate?",
      options: [
        "No relationship",
        "Statistical significance",
        "Poor data quality",
        "Large sample size"
      ],
      correctAnswer: 1,
      explanation:
          "A p-value below 0.05 commonly indicates statistically significant evidence against the null hypothesis.",
      difficulty: "Hard",
    ),

    QuizQuestion(
      question: "Correlation measures:",
      options: [
        "Causation",
        "Association between variables",
        "Sample size",
        "Probability"
      ],
      correctAnswer: 1,
      explanation:
          "Correlation measures the strength and direction of association between variables, not causation.",
      difficulty: "Easy",
    ),
  ];

  List<QuizQuestion> generateQuiz({
    int numberOfQuestions = 5,
    String? difficulty,
  }) {

    List<QuizQuestion> questions = _questionBank;

    if (difficulty != null) {
      questions = questions
          .where(
            (q) =>
                q.difficulty.toLowerCase() ==
                difficulty.toLowerCase(),
          )
          .toList();
    }

    if (questions.length > numberOfQuestions) {
      questions = questions.take(numberOfQuestions).toList();
    }

    return questions;
  }

  int markQuiz(
    List<int> studentAnswers,
    List<QuizQuestion> quiz,
  ) {

    int score = 0;

    for (int i = 0; i < quiz.length; i++) {
      if (i < studentAnswers.length &&
          studentAnswers[i] == quiz[i].correctAnswer) {
        score++;
      }
    }

    return score;
  }

  double percentage(
    int score,
    int total,
  ) {
    if (total == 0) return 0;

    return (score / total) * 100;
  }

  String performanceMessage(double percentage) {

    if (percentage >= 90) {
      return "Excellent performance!";
    }

    if (percentage >= 75) {
      return "Very good work.";
    }

    if (percentage >= 50) {
      return "Good effort. Keep revising.";
    }

    return "Joseph recommends more revision before the next quiz.";
  }
}