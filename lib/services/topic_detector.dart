class TopicDetector {
  final Map<String, List<String>> _topics = {
    // ----------------------------
    // Epidemiology
    // ----------------------------
    "Epidemiology": [
      "epidemiology",
      "outbreak",
      "incidence",
      "prevalence",
      "attack rate",
      "surveillance",
      "risk factor",
      "screening",
      "epidemic",
      "pandemic",
      "endemic",
      "cohort",
      "case control",
      "cross sectional",
    ],

    // ----------------------------
    // Medical Biostatistics
    // ----------------------------
    "Biostatistics": [
      "anova",
      "regression",
      "correlation",
      "hypothesis",
      "chi-square",
      "confidence interval",
      "variance",
      "standard deviation",
      "mean",
      "median",
      "mode",
      "probability",
      "t-test",
      "z-test",
      "sampling",
      "normal distribution",
    ],

    // ----------------------------
    // Public Health
    // ----------------------------
    "Public Health": [
      "public health",
      "health promotion",
      "community",
      "vaccination",
      "policy",
      "primary health care",
      "universal health coverage",
      "sdg",
      "health system",
    ],

    // ----------------------------
    // Research
    // ----------------------------
    "Research": [
      "research",
      "methodology",
      "study design",
      "sample size",
      "questionnaire",
      "literature review",
      "data collection",
      "analysis",
    ],

    // ----------------------------
    // Anatomy
    // ----------------------------
    "Anatomy": [
      "bone",
      "muscle",
      "heart",
      "brain",
      "artery",
      "vein",
      "organ",
      "skeletal",
      "thorax",
      "abdomen",
    ],

    // ----------------------------
    // Physiology
    // ----------------------------
    "Physiology": [
      "homeostasis",
      "respiration",
      "circulation",
      "renal",
      "digestion",
      "blood pressure",
      "endocrine",
      "nervous system",
    ],

    // ----------------------------
    // Health Informatics
    // ----------------------------
    "Health Informatics": [
      "ehr",
      "electronic health record",
      "hospital information system",
      "health informatics",
      "database",
      "data quality",
      "health information",
    ],
  };

  List<String> detectTopics(String text) {
    final lower = text.toLowerCase();

    final detected = <String>{};

    _topics.forEach((topic, keywords) {
      for (final keyword in keywords) {
        if (lower.contains(keyword)) {
          detected.add(topic);
          break;
        }
      }
    });

    return detected.toList();
  }

  List<String> detectKeywords(String text) {
    final lower = text.toLowerCase();

    final keywords = <String>{};

    for (final group in _topics.values) {
      for (final keyword in group) {
        if (lower.contains(keyword)) {
          keywords.add(keyword);
        }
      }
    }

    return keywords.toList();
  }

  Map<String, int> topicScores(String text) {
    final lower = text.toLowerCase();

    final scores = <String, int>{};

    _topics.forEach((topic, keywords) {
      int score = 0;

      for (final keyword in keywords) {
        if (lower.contains(keyword)) {
          score++;
        }
      }

      if (score > 0) {
        scores[topic] = score;
      }
    });

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