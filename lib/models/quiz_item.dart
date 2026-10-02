// A single multiple-choice question.
class QuizItem {
  final String question;
  final List<String> options;
  final int correctIndex;

  const QuizItem({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}