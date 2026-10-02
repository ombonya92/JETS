import '../utils/text_matcher.dart';

class AcademicKnowledgeEngine {
  const AcademicKnowledgeEngine();

  static const Map<String, String> _definitions = {
    'quadratic':
        'A quadratic equation is an equation of degree two written as '
            'ax^2 + bx + c = 0.',
    'derivative':
        'A derivative measures the rate of change of a function with respect '
            'to a variable.',
    'integration':
        'Integration is the reverse of differentiation and is used to '
            'calculate area under curves.',
    'pythagoras':
        'Pythagoras theorem states that a^2 + b^2 = c^2 for a right-angled '
            'triangle.',
    'anova':
        'ANOVA (Analysis of Variance) compares the means of three or more '
            'groups.',
    'regression':
        'Regression determines relationships between dependent and '
            'independent variables.',
    'correlation':
        'Correlation measures the strength and direction of association '
            'between variables.',
    'chi-square':
        'Chi-square tests relationships between categorical variables.',
    't-test': 'A t-test compares the means of two groups.',
    'probability': 'Probability measures the likelihood of an event occurring.',
    'photosynthesis':
        'Photosynthesis converts sunlight into chemical energy using '
            'chlorophyll.',
    'cell': 'The cell is the basic structural and functional unit of life.',
    'mitosis': 'Mitosis produces two genetically identical daughter cells.',
    'atom': 'An atom is the smallest unit of an element.',
    'acid': 'An acid donates hydrogen ions (H+).',
    'base': 'A base accepts hydrogen ions or releases hydroxide ions.',
    'newton': "Newton's Laws describe motion, force and inertia.",
    'velocity': 'Velocity is speed in a specified direction.',
    'force': 'Force is any push or pull that changes motion.',
    'python':
        'Python is a high-level programming language used in AI, web, '
            'automation and data science.',
    'flutter':
        "Flutter is Google's framework for building Android, iOS, Web and "
            'Desktop apps.',
    'algorithm': 'An algorithm is a sequence of steps used to solve a problem.',
    'loop': 'A loop repeats instructions until a condition changes.',
    'epidemiology':
        'Epidemiology studies the distribution and determinants of diseases '
            'in populations.',
    'incidence':
        'Incidence is the number of new disease cases during a specified '
            'period.',
    'prevalence':
        'Prevalence is the total number of existing disease cases in a '
            'population.',
    'screening': 'Screening identifies disease before symptoms appear.',
  };

  static const Map<String, String> _displayNames = {
    'anova': 'ANOVA',
  };

  // All known terms mapped to their definitions, in a stable order.
  Map<String, String> get definitions => _definitions;

  // Returns the definition of [term], or null when the term is unknown.
  String? definitionFor(String term) {
    return _definitions[term.trim().toLowerCase()];
  }

  // Returns every known term mentioned in [text] with its definition.
  Map<String, String> definitionsIn(String text) {
    return {
      for (final entry in _definitions.entries)
        if (TextMatcher.containsTerm(text, entry.key)) entry.key: entry.value,
    };
  }

  // Returns [term] formatted for display to the student.
  String displayName(String term) {
    final normalized = term.trim().toLowerCase();
    final special = _displayNames[normalized];

    if (special != null) {
      return special;
    }

    if (normalized.isEmpty) {
      return normalized;
    }

    return normalized[0].toUpperCase() + normalized.substring(1);
  }
}