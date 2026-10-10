import '../models/academic_domain.dart';
import '../utils/text_matcher.dart';

class AcademicDomainDetector {
  const AcademicDomainDetector();

  AcademicDomain? detectDomain(List<String> detectedTopics) {
    for (final domain in AcademicDomains.domains) {
      for (final subject in domain.subjects) {
        if (detectedTopics.any(
          (topic) => topic.toLowerCase() == subject.toLowerCase(),
        )) {
          return domain;
        }
      }
    }

    return null;
  }

  List<AcademicDomain> detectDomains(String text) {
    return AcademicDomains.domains
        .where((domain) => TextMatcher.containsAny(text, domain.subjects))
        .toList();
  }

  String detectDomainName(List<String> detectedTopics) {
    return detectDomain(detectedTopics)?.name ?? 'General Academics';
  }

  List<String> relatedSubjects(List<String> detectedTopics) {
    final domain = detectDomain(detectedTopics);

    if (domain == null) {
      return [];
    }

    return List<String>.of(domain.subjects);
  }
}