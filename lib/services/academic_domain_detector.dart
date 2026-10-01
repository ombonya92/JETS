import '../models/academic_domain.dart';

class AcademicDomainDetector {
  const AcademicDomainDetector();

  AcademicDomain? detectDomain(List<String> detectedTopics) {
    for (final domain in AcademicDomains.domains) {
      for (final subject in domain.subjects) {
        if (detectedTopics.any(
          (topic) =>
              topic.toLowerCase() ==
              subject.toLowerCase(),
        )) {
          return domain;
        }
      }
    }

    return null;
  }

  List<AcademicDomain> detectDomains(String text) {
    final lower = text.toLowerCase();

    final List<AcademicDomain> matches = [];

    for (final domain in AcademicDomains.domains) {
      bool found = false;

      for (final subject in domain.subjects) {
        if (lower.contains(subject.toLowerCase())) {
          found = true;
          break;
        }
      }

      if (found) {
        matches.add(domain);
      }
    }

    return matches;
  }

  String detectDomainName(
      List<String> detectedTopics) {
    return detectDomain(detectedTopics)?.name ??
        "General Academics";
  }

  List<String> relatedSubjects(
      List<String> detectedTopics) {
    final domain =
        detectDomain(detectedTopics);

    if (domain == null) {
      return [];
    }

    return List.from(domain.subjects);
  }
}