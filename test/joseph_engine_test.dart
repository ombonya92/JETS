import 'package:flutter_test/flutter_test.dart';
import 'package:jets/core/app_controller.dart';
import 'package:jets/models/document_action.dart';
import 'package:jets/models/document_analysis.dart';

DocumentAnalysis _document({
  String text = 'ANOVA and regression notes.',
  List<String> keywords = const ['anova', 'regression'],
}) {
  return DocumentAnalysis(
    fileName: 'stats.pdf',
    pageCount: 3,
    subjects: const ['Mathematics'],
    keywords: keywords,
    summary: '',
    text: text,
  );
}

void main() {
  final controller = AppController.instance;
  final cognitive = controller.cognitive;

  group('document actions', () {
    test('generate quiz builds questions from document keywords', () {
      final reply = cognitive.respondToDocument(
        DocumentAction.generateQuiz,
        _document(),
      );

      expect(reply, contains('Quiz from stats.pdf'));
      expect(reply, contains('Answer key:'));
    });

    test('generate quiz explains when no topic is supported', () {
      final reply = cognitive.respondToDocument(
        DocumentAction.generateQuiz,
        _document(keywords: const ['hypothesis testing']),
      );

      expect(reply, contains('could not build quiz questions'));
      expect(reply, isNot(contains('Answer key')));
    });

    test('ask about document lists topics Joseph can explain', () {
      final reply = cognitive.respondToDocument(
        DocumentAction.askAboutDocument,
        _document(),
      );

      expect(reply, contains('ANOVA'));
      expect(reply, contains('Regression'));
    });

    test('every action reports unreadable documents', () {
      final empty = _document(text: '', keywords: const []);

      for (final action in [
        DocumentAction.summarize,
        DocumentAction.importantTopics,
        DocumentAction.generateQuestions,
        DocumentAction.examPrediction,
        DocumentAction.studyPlan,
        DocumentAction.revisionNotes,
      ]) {
        expect(cognitive.respondToDocument(action, empty), isNotEmpty);
      }
    });

    test('important topics respects word boundaries', () {
      final reply = cognitive.respondToDocument(
        DocumentAction.importantTopics,
        _document(text: 'We store records in a database.'),
      );

      expect(reply, contains('- database'));
      expect(reply, isNot(contains('- base')));
    });
  });

  group('chat routing', () {
    test('quiz request returns a quiz even when a topic is named', () {
      final reply = cognitive.respond('quiz anova');

      expect(reply, contains('Quiz on ANOVA'));
      expect(reply, contains('What is the main purpose of ANOVA?'));
      expect(reply, contains('Answer key: 1-A, 2-B'));
    });

    test('definition request returns a definition', () {
      final reply = cognitive.respond('what is anova');

      expect(reply, contains('Analysis of Variance'));
      expect(reply, contains('quiz anova'));
    });

    test('substrings of longer words do not trigger definitions', () {
      final reply = cognitive.respond('tell me about my database');

      expect(reply, isNot(contains('hydrogen')));
      expect(reply, contains('I do not have an answer'));
    });
  });

  group('learning wiring', () {
    test('uploading a document updates memory and timeline', () {
      final before = controller.memory.profile.totalUploads;

      controller.intelligence.analyze(
        fileName: 'biostatistics.pdf',
        text: 'Regression and ANOVA are core topics. '
            'Hypothesis testing follows.',
      );

      expect(controller.memory.profile.totalUploads, before + 1);
      expect(controller.memory.uploadedFiles, contains('biostatistics.pdf'));
      expect(
        controller.timeline.events.any(
          (event) =>
              event.title == 'Uploaded Notes' &&
              event.description == 'biostatistics.pdf',
        ),
        isTrue,
      );
    });

    test('asking a question is recorded on the timeline', () {
      cognitive.respond('explain correlation');

      expect(
        controller.timeline.events.any(
          (event) =>
              event.title == 'Asked Joseph' &&
              event.description == 'explain correlation',
        ),
        isTrue,
      );
    });
  });
}