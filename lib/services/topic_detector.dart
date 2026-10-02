import '../utils/text_matcher.dart';

class TopicDetector {
  static const Map<String, List<String>> _topics = {
    'Epidemiology': [
      'epidemiology',
      'outbreak',
      'incidence',
      'prevalence',
      'attack rate',
      'surveillance',
      'risk factor',
      'screening',
      'epidemic',
      'pandemic',
      'endemic',
      'cohort',
      'case control',
      'cross sectional',
    ],
    'Biostatistics': [
      'anova',
      'regression',
      'correlation',
      'hypothesis',
      'chi-square',
      'confidence interval',
      'variance',
      'standard deviation',
      'mean',
      'median',
      'mode',
      'probability',
      't-test',
      'z-test',
      'sampling',
      'normal distribution',
    ],
    'Public Health': [
      'public health',
      'health promotion',
      'community',
      'vaccination',
      'policy',
      'primary health care',
      'universal health coverage',
      'sdg',
      'health system',
    ],
    'Research': [
      'research',
      'methodology',
      'study design',
      'sample size',
      'questionnaire',
      'literature review',
      'data collection',
      'analysis',
    ],
    'Anatomy': [
      'bone',
      'muscle',
      'heart',
      'brain',
      'artery',
      'vein',
      'organ',
      'skeletal',
      'thorax',
      'abdomen',
    ],
    'Physiology': [
      'homeostasis',
      'respiration',
      'circulation',
      'renal',
      'digestion',
      'blood pressure',
      'endocrine',
      'nervous system',
    ],
    'Health Informatics': [
      'ehr',
      'electronic health record',
      'hospital information system',
      'health informatics',
      'database',
      'data quality',
      'health information',
    ],
  };

  List<String> detectTopics(String text) {
    return [
      for (final entry in _topics.entries)
        if (TextMatcher.containsAny(text, entry.value)) entry.key,
    ];
  }

  List<String> detectKeywords(String text) {
    final keywords = <String>{};

    for (final group in _topics.values) {
      keywords.addAll(TextMatcher.matchingTerms(text, group));
    }

    return keywords.toList();
  }

  Map<String, int> topicScores(String text) {
    final scores = <String, int>{};

    for (final entry in _topics.entries) {
      final score = TextMatcher.matchingTerms(text, entry.value).length;

      if (score > 0) {
        scores[entry.key] = score;
      }
    }

    return scores;
  }

  String? primaryTopic(String text) {
    final scores = topicScores(text);

    if (scores.isEmpty) {
      return null;
    }

    return scores.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}