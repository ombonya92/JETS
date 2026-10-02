import 'package:flutter_test/flutter_test.dart';
import 'package:jets/utils/text_matcher.dart';

void main() {
  group('TextMatcher', () {
    test('matches whole words regardless of case', () {
      expect(TextMatcher.containsTerm('Explain ANOVA now', 'anova'), isTrue);
      expect(TextMatcher.containsTerm('explain anova now', 'ANOVA'), isTrue);
    });

    test('does not match inside longer words', () {
      expect(TextMatcher.containsTerm('a database', 'base'), isFalse);
      expect(TextMatcher.containsTerm('an excellent result', 'cell'), isFalse);
      expect(TextMatcher.containsTerm('wrapped tightly', 'rap'), isFalse);
      expect(TextMatcher.containsTerm('the meaning of it', 'mean'), isFalse);
    });

    test('matches simple plurals', () {
      expect(TextMatcher.containsTerm('animal cells divide', 'cell'), isTrue);
      expect(TextMatcher.containsTerm('acids and bases', 'base'), isTrue);
    });

    test('matches hyphenated and multi-word terms', () {
      expect(TextMatcher.containsTerm('run a t-test now', 't-test'), isTrue);
      expect(
        TextMatcher.containsTerm('hypothesis testing 101', 'hypothesis testing'),
        isTrue,
      );
    });

    test('ignores empty terms', () {
      expect(TextMatcher.containsTerm('anything', '  '), isFalse);
    });

    test('matchingTerms keeps input order', () {
      final terms = TextMatcher.matchingTerms(
        'regression and anova',
        ['anova', 'cell', 'regression'],
      );

      expect(terms, ['anova', 'regression']);
    });
  });
}