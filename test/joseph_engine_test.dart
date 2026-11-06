import 'package:flutter_test/flutter_test.dart';
import 'package:jets/core/app_controller.dart';
import 'package:jets/models/document_action.dart';
import 'package:jets/models/document_analysis.dart';
import 'package:jets/models/document_record.dart';
import 'package:jets/models/study_task.dart';
import 'package:jets/state/app_state.dart';
import 'package:jets/utils/text_matcher.dart';

DocumentAnalysis _analysis({
  String text = 'ANOVA and regression notes.',
  List<String> keywords = const ['anova', 'regression'],
  List<String> subjects = const ['Mathematics'],
}) {
  return DocumentAnalysis(
    fileName: 'stats.pdf',
    pageCount: 3,
    subjects: subjects,
    keywords: keywords,
    summary: '',
    text: text,
  );
}

DocumentRecord _record(DocumentAnalysis a) {
  return DocumentRecord(
    id: AppState.generateId(),
    fileName: a.fileName,
    pageCount: a.pageCount,
    subjects: a.subjects,
    keywords: a.keywords,
    uploadedAt: DateTime.now(),
  );
}

void main() {
  final controller = AppController.instance;
  final cognitive = controller.cognitive;
  final state = controller.state;

  group('TextMatcher', () {
    test('matches whole word regardless of case', () {
      expect(TextMatcher.containsTerm('Explain ANOVA now', 'anova'), isTrue);
      expect(TextMatcher.containsTerm('explain anova now', 'ANOVA'), isTrue);
    });

    test('does not match inside a longer word', () {
      expect(TextMatcher.containsTerm('a database', 'base'), isFalse);
      expect(TextMatcher.containsTerm('an excellent result', 'cell'), isFalse);
      expect(TextMatcher.containsTerm('the meaning of it', 'mean'), isFalse);
    });

    test('matches simple plurals', () {
      expect(TextMatcher.containsTerm('animal cells divide', 'cell'), isTrue);
      expect(TextMatcher.containsTerm('acids and bases react', 'base'), isTrue);
    });

    test('matches hyphenated terms', () {
      expect(TextMatcher.containsTerm('run a t-test now', 't-test'), isTrue);
    });

    test('containsAny returns true when at least one term matches', () {
      expect(
        TextMatcher.containsAny('quiz me on anova', ['quiz', 'exam']),
        isTrue,
      );
      expect(
        TextMatcher.containsAny('study plan please', ['quiz', 'exam']),
        isFalse,
      );
    });

    test('matchingTerms returns matched terms in input order', () {
      final terms = TextMatcher.matchingTerms(
        'regression and anova notes',
        ['anova', 'cell', 'regression'],
      );
      expect(terms, ['anova', 'regression']);
    });
  });

  group('Document actions', () {
    test('generate quiz builds questions from document keywords', () {
      final reply = cognitive.respondToDocument(
        DocumentAction.generateQuiz,
        _analysis(),
      );
      expect(reply, contains('Quiz from stats.pdf'));
      expect(reply, contains('Answer key:'));
    });

    test('generate quiz falls back gracefully for unknown topics', () {
      final reply = cognitive.respondToDocument(
        DocumentAction.generateQuiz,
        _analysis(keywords: const ['hypothesis testing']),
      );
      expect(reply, contains('could not build quiz questions'));
      expect(reply, isNot(contains('Answer key')));
    });

    test('ask about document lists explainable topics', () {
      final reply = cognitive.respondToDocument(
        DocumentAction.askAboutDocument,
        _analysis(),
      );
      expect(reply, contains('ANOVA'));
      expect(reply, contains('Regression'));
    });

    test('all actions return non-empty text for unreadable documents', () {
      final empty = _analysis(text: '', keywords: const []);
      for (final action in DocumentAction.values) {
        expect(
          cognitive.respondToDocument(action, empty),
          isNotEmpty,
          reason: '$action should not return empty string',
        );
      }
    });

    test('important topics respects word boundaries', () {
      final reply = cognitive.respondToDocument(
        DocumentAction.importantTopics,
        _analysis(text: 'We store records in a database.'),
      );
      expect(reply, contains('- database'));
      expect(reply, isNot(contains('- base')));
    });

    test('summarize returns filename and content excerpt', () {
      final reply = cognitive.respondToDocument(
        DocumentAction.summarize,
        _analysis(text: 'ANOVA compares group means.'),
      );
      expect(reply, contains('stats.pdf'));
      expect(reply, contains('ANOVA'));
    });
  });

  group('Chat routing', () {
    test('quiz request returns quiz for named topic', () {
      final reply = cognitive.respond('quiz anova');
      expect(reply, contains('Quiz on ANOVA'));
      expect(reply, contains('What is the main purpose of ANOVA?'));
      expect(reply, contains('Answer key: 1-A, 2-B'));
    });

    test('definition request returns definition and quiz prompt', () {
      final reply = cognitive.respond('what is anova');
      expect(reply, contains('Analysis of Variance'));
      expect(reply, contains('quiz anova'));
    });

    test('substring of longer word does not trigger definition', () {
      final reply = cognitive.respond('tell me about my database');
      expect(reply, isNot(contains('hydrogen')));
      expect(reply, contains('I do not have an answer'));
    });

    test('greeting returns non-empty response', () {
      final reply = cognitive.respond('hello');
      expect(reply, isNotEmpty);
    });

    test('progress query returns level and counts', () {
      final reply = cognitive.respond('my progress');
      expect(reply, contains('Learning level'));
      expect(reply, contains('Uploads'));
    });

    test('fallback returns help text for unknown input', () {
      final reply = cognitive.respond('xyzzy unknown 12345');
      expect(reply, contains('I do not have an answer'));
    });
  });

  group('Learning wiring', () {
    test('analyzeRecord increments upload count and records timeline event',
        () async {
      final a = _analysis(
        text: 'Regression and ANOVA are core topics.',
        keywords: const ['regression', 'anova'],
      );
      final before = controller.memory.profile.totalUploads;

      await controller.intelligence.analyzeRecord(_record(a), a.text);

      expect(controller.memory.profile.totalUploads, before + 1);
      expect(controller.memory.uploadedFiles, contains('stats.pdf'));
      expect(
        controller.timeline.events.any(
          (e) =>
              e.title == 'Uploaded Notes' && e.description == 'stats.pdf',
        ),
        isTrue,
      );
    });

    test('asking a question increments question count and records timeline',
        () {
      final before = controller.memory.profile.totalQuestions;
      cognitive.respond('explain correlation');
      expect(controller.memory.profile.totalQuestions, before + 1);
      expect(
        controller.timeline.events.any(
          (e) =>
              e.title == 'Asked Joseph' &&
              e.description == 'explain correlation',
        ),
        isTrue,
      );
    });

    test('quiz with passing score marks topic as strong', () {
      cognitive.observeQuiz(topic: 'ANOVA', score: 90);
      expect(controller.memory.strongTopics, contains('ANOVA'));
    });

    test('quiz with failing score marks topic as weak', () {
      cognitive.observeQuiz(topic: 'Correlation', score: 40);
      expect(controller.memory.weakTopics, contains('Correlation'));
    });

    test('analyze convenience method also increments upload count', () async {
      final before = controller.memory.profile.totalUploads;
      await controller.intelligence.analyze(
        fileName: 'biostatistics.pdf',
        text: 'Regression and ANOVA are core topics.',
      );
      expect(controller.memory.profile.totalUploads, before + 1);
    });
  });

  group('Task CRUD', () {
    test('addTask adds to task list', () async {
      final before = state.tasks.length;
      await state.addTask(StudyTask(
        id: AppState.generateId(),
        title: 'Review Chapter 3',
      ));
      expect(state.tasks.length, before + 1);
      expect(state.tasks.first.title, 'Review Chapter 3');
    });

    test('completeTask marks task as completed', () async {
      await state.addTask(StudyTask(id: 'tc-1', title: 'Task to complete'));
      await state.completeTask('tc-1');
      expect(
        state.tasks.any((t) => t.id == 'tc-1' && t.completed),
        isTrue,
      );
    });

    test('updateTask changes title and description', () async {
      await state.addTask(StudyTask(id: 'tu-1', title: 'Original'));
      await state.updateTask(
        StudyTask(id: 'tu-1', title: 'Updated', description: 'New desc'),
      );
      final task = state.tasks.firstWhere((t) => t.id == 'tu-1');
      expect(task.title, 'Updated');
      expect(task.description, 'New desc');
    });

    test('deleteTask removes from list', () async {
      await state.addTask(StudyTask(id: 'td-1', title: 'To delete'));
      await state.deleteTask('td-1');
      expect(state.tasks.any((t) => t.id == 'td-1'), isFalse);
    });
  });

  group('Input safety', () {
    test('empty input does not crash', () {
      expect(() => cognitive.respond(''), returnsNormally);
    });

    test('very long input is handled without error', () {
      expect(() => cognitive.respond('anova ' * 500), returnsNormally);
    });

    test('special characters do not cause errors', () {
      expect(
        () => cognitive.respond('<script>alert("xss")</script>'),
        returnsNormally,
      );
    });
  });
}