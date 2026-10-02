// Whole-word, case-insensitive term matching.
//Plain substring checks produce false positives such as "base" inside
// "database" or "cell" inside "excellent". A term matches only when it is
// not part of a longer word. A simple plural ("cells", "bases") also matches.
class TextMatcher {
  const TextMatcher._();

  static final Map<String, RegExp> _patterns = <String, RegExp>{};

  //Returns true when [term] appears in [text] as a whole word.
  static bool containsTerm(String text, String term) {
    final normalized = term.trim().toLowerCase();

    if (normalized.isEmpty) {
      return false;
    }

    return _patternFor(normalized).hasMatch(text);
  }

  //Returns true when at least one of [terms] appears in [text].
  static bool containsAny(String text, Iterable<String> terms) {
    return terms.any((term) => containsTerm(text, term));
  }

  //Returns the subset of [terms] that appear in [text], in input order.
  static List<String> matchingTerms(String text, Iterable<String> terms) {
    return terms.where((term) => containsTerm(text, term)).toList();
  }

  static RegExp _patternFor(String term) {
    return _patterns.putIfAbsent(
      term,
      () => RegExp(
        '\\b${RegExp.escape(term)}(?:s|es)?\\b',
        caseSensitive: false,
      ),
    );
  }
}