import 'dart:typed_data';

import 'package:syncfusion_flutter_pdf/pdf.dart';

class DocumentService {
  Future<Map<String, dynamic>> analyzePdf(
    Uint8List bytes,
    String fileName,
  ) async {
    final document = PdfDocument(inputBytes: bytes);

    try {
      final pageCount = document.pages.count;

      final extractedText = PdfTextExtractor(document).extractText();

      final text = extractedText.trim();

      final subjects = _detectSubjects(text);
      final keywords = _detectKeywords(text);

      final summary = _createSummary(
        fileName: fileName,
        text: text,
        subjects: subjects,
        keywords: keywords,
      );

      return {
        "fileName": fileName,
        "pages": pageCount,
        "subjects": subjects,
        "keywords": keywords,
        "summary": summary,
        "text": text,
      };
    } finally {
      document.dispose();
    }
  }

  List<String> _detectSubjects(String text) {
    final lower = text.toLowerCase();

    final subjectRules = <String, List<String>>{
      "Mathematics": [
        "algebra",
        "calculus",
        "equation",
        "quadratic",
        "matrix",
        "geometry",
        "trigonometry",
        "statistics",
        "probability",
      ],
      "Biology": [
        "cell",
        "mitosis",
        "meiosis",
        "genetics",
        "photosynthesis",
        "organism",
        "ecosystem",
        "dna",
        "rna",
      ],
      "Chemistry": [
        "atom",
        "molecule",
        "chemical",
        "reaction",
        "acid",
        "base",
        "organic chemistry",
        "periodic table",
      ],
      "Physics": [
        "force",
        "velocity",
        "acceleration",
        "momentum",
        "energy",
        "motion",
        "newton",
        "electricity",
        "wave",
      ],
      "Computer Science": [
        "algorithm",
        "programming",
        "python",
        "computer",
        "database",
        "software",
        "network",
        "data structure",
      ],
      "Medicine": [
        "patient",
        "diagnosis",
        "disease",
        "clinical",
        "anatomy",
        "physiology",
        "pathology",
        "treatment",
      ],
      "Nursing": [
        "nursing",
        "patient care",
        "clinical",
        "diagnosis",
        "vital signs",
        "medication",
      ],
      "Epidemiology": [
        "epidemiology",
        "incidence",
        "prevalence",
        "outbreak",
        "surveillance",
        "screening",
        "risk factor",
      ],
      "Economics": [
        "economics",
        "demand",
        "supply",
        "inflation",
        "market",
        "gdp",
        "unemployment",
      ],
      "Psychology": [
        "psychology",
        "behavior",
        "cognition",
        "memory",
        "personality",
        "learning",
      ],
      "History": [
        "history",
        "war",
        "colonial",
        "revolution",
        "empire",
        "civilization",
      ],
      "Geography": [
        "geography",
        "climate",
        "population",
        "map",
        "environment",
        "landform",
      ],
    };

    final detected = <String>[];

    for (final entry in subjectRules.entries) {
      final matches = entry.value.where(
        (keyword) => lower.contains(keyword),
      );

      if (matches.isNotEmpty) {
        detected.add(entry.key);
      }
    }

    if (detected.isEmpty) {
      return ["General Academics"];
    }

    return detected;
  }

  List<String> _detectKeywords(String text) {
    final lower = text.toLowerCase();

    final possibleKeywords = [
      "algebra",
      "calculus",
      "statistics",
      "probability",
      "regression",
      "correlation",
      "anova",
      "hypothesis testing",
      "cell",
      "genetics",
      "photosynthesis",
      "mitosis",
      "meiosis",
      "atom",
      "chemical reaction",
      "acid",
      "base",
      "organic chemistry",
      "force",
      "velocity",
      "acceleration",
      "momentum",
      "energy",
      "newton's laws",
      "programming",
      "algorithm",
      "python",
      "database",
      "anatomy",
      "physiology",
      "pathology",
      "disease",
      "diagnosis",
      "epidemiology",
      "incidence",
      "prevalence",
      "outbreak",
      "screening",
      "economics",
      "supply",
      "demand",
      "inflation",
      "psychology",
      "behavior",
      "history",
      "geography",
    ];

    final found = <String>[];

    for (final keyword in possibleKeywords) {
      if (lower.contains(keyword)) {
        found.add(keyword);
      }
    }

    return found.take(15).toList();
  }

  String _createSummary({
    required String fileName,
    required String text,
    required List<String> subjects,
    required List<String> keywords,
  }) {
    if (text.isEmpty) {
      return """
Joseph received "$fileName", but no readable text was found.

The PDF may contain scanned images rather than selectable text.
""";
    }

    final preview = text
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final shortened = preview.length > 600
        ? "${preview.substring(0, 600)}..."
        : preview;

    return """
Joseph analysed "$fileName".

Pages: The document contains ${subjects.length} detected academic area(s).

Detected subject areas:
${subjects.map((s) => "• $s").join("\n")}

Detected topics:
${keywords.isEmpty ? "No specific keywords detected yet." : keywords.map((k) => "• $k").join("\n")}

Document preview:
$shortened
""";
  }
}