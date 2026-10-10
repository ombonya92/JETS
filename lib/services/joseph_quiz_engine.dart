import '../models/quiz_item.dart';
import 'academic_knowledge_engine.dart';

class JosephQuizEngine {
  final AcademicKnowledgeEngine knowledge;

  const JosephQuizEngine(this.knowledge);

  static const int defaultQuestionLimit = 5;

  static const int _optionCount = 4;

  static const Map<String, List<QuizItem>> _topicBank = {
    'anova': [
      QuizItem(
        question: 'What is the main purpose of ANOVA?',
        options: [
          'Compare means',
          'Compare proportions',
          'Measure correlation',
          'Predict values',
        ],
        correctIndex: 0,
      ),
      QuizItem(
        question: 'ANOVA is commonly used when comparing:',
        options: [
          '2 groups',
          '3 or more groups',
          'Percentages',
          'Probabilities',
        ],
        correctIndex: 1,
      ),
    ],
    'python': [
      QuizItem(
        question: 'Python is mainly a:',
        options: [
          'Database',
          'Programming language',
          'Web browser',
          'Compiler',
        ],
        correctIndex: 1,
      ),
    ],
  };

  // Builds up to [limit] questions covering the given [topics].
  // Topics with a hand-written question bank use it. Other topics known to
  // the knowledge engine get a "which statement describes" question built
  //from their definition. Unknown topics are skipped.
  List<QuizItem> generateForTopics(
    Iterable<String> topics, {
    int limit = defaultQuestionLimit,
  }) {
    final items = <QuizItem>[];

    for (final topic in topics) {
      items.addAll(_itemsFor(topic));

      if (items.length >= limit) {
        break;
      }
    }

    return items.take(limit).toList();
  }

  // Formats [items] as plain text followed by an answer key.
  String render(String title, List<QuizItem> items) {
    final buffer = StringBuffer('$title\n\n');

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      buffer.writeln('${i + 1}. ${item.question}');

      for (int j = 0; j < item.options.length; j++) {
        buffer.writeln('   ${_letter(j)}. ${item.options[j]}');
      }

      buffer.writeln();
    }

    final answers = [
      for (int i = 0; i < items.length; i++)
        '${i + 1}-${_letter(items[i].correctIndex)}',
    ];

    buffer.write('Answer key: ${answers.join(', ')}');

    return buffer.toString();
  }

  List<QuizItem> _itemsFor(String topic) {
    final key = topic.trim().toLowerCase();

    final banked = _topicBank[key];

    if (banked != null) {
      return banked;
    }

    final generated = _definitionItem(key);

    return generated == null ? const [] : [generated];
  }

  QuizItem? _definitionItem(String key) {
    final entries = knowledge.definitions.entries.toList();
    final index = entries.indexWhere((entry) => entry.key == key);

    if (index == -1 || entries.length < _optionCount) {
      return null;
    }

    final options = <String>[
      for (int offset = 1; offset < _optionCount; offset++)
        entries[(index + offset) % entries.length].value,
    ];

    final correctIndex = index % _optionCount;

    options.insert(correctIndex, entries[index].value);

    return QuizItem(
      question: 'Which statement best describes ${knowledge.displayName(key)}?',
      options: options,
      correctIndex: correctIndex,
    );
  }

  String _letter(int index) => String.fromCharCode(65 + index);
}