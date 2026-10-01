class JosephDocumentEngine {
  const JosephDocumentEngine();

  String summarize({
    required String fileName,
    required String text,
  }) {
    if (text.trim().isEmpty) {
      return "Joseph could not find readable text in $fileName.";
    }

    final cleanText = text
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final summary = cleanText.length > 1200
        ? "${cleanText.substring(0, 1200)}..."
        : cleanText;

    return """
📚 Summary of $fileName

$summary
""";
  }

  String importantTopics({
    required String text,
  }) {
    if (text.trim().isEmpty) {
      return "No readable topics were found.";
    }

    final lower = text.toLowerCase();

    final possibleTopics = [
      "algebra",
      "calculus",
      "statistics",
      "probability",
      "regression",
      "correlation",
      "anova",
      "hypothesis testing",
      "biology",
      "cell",
      "genetics",
      "photosynthesis",
      "chemistry",
      "atom",
      "chemical reaction",
      "acid",
      "base",
      "physics",
      "force",
      "velocity",
      "acceleration",
      "momentum",
      "energy",
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
      "psychology",
      "behavior",
      "history",
      "geography",
    ];

    final found = possibleTopics
        .where((topic) => lower.contains(topic))
        .toList();

    if (found.isEmpty) {
      return "Joseph could not identify specific topics yet.";
    }

    return """
📌 Important Topics

${found.map((topic) => "• $topic").join("\n")}
""";
  }

  String generateQuestions({
    required String text,
  }) {
    if (text.trim().isEmpty) {
      return "Joseph needs readable document content to generate questions.";
    }

    final topics = importantTopics(text: text);

    return """
📝 Study Questions

Based on the uploaded document, review these areas:

$topics

Possible questions:

1. Define the main concepts discussed in the document.

2. Explain the important principles covered.

3. Describe the major processes or procedures discussed.

4. Differentiate between important related concepts.

5. Explain the importance of the major topics identified.

6. Give examples related to the concepts discussed.

7. Discuss possible applications of the knowledge covered.
""";
  }

  String examPrediction({
    required String text,
  }) {
    if (text.trim().isEmpty) {
      return "Joseph needs readable document content before making an exam-focused analysis.";
    }

    final topics = importantTopics(text: text);

    return """
🎯 Possible Exam Areas

Joseph identified these topics in the uploaded material:

$topics

Areas worth revising carefully:

• Definitions and key concepts
• Explanations of major principles
• Differences between related concepts
• Applications and examples
• Processes and procedures
• Short-answer questions
• Discussion questions
""";
  }

  String revisionNotes({
    required String text,
  }) {
    if (text.trim().isEmpty) {
      return "No readable document content was found.";
    }

    final cleanText = text
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final notes = cleanText.length > 1800
        ? "${cleanText.substring(0, 1800)}..."
        : cleanText;

    return """
📖 Revision Notes

$notes

──────────────────

Focus on:
• Key definitions
• Main concepts
• Important processes
• Examples
• Possible examination areas
""";
  }

  String studyPlan({
    required String text,
  }) {
    final topics = importantTopics(text: text);

    return """
📅 Study Plan

Topics identified:

$topics

Suggested approach:

Day 1
• Read and understand the major concepts.

Day 2
• Review definitions and important principles.

Day 3
• Practice questions from the material.

Day 4
• Review difficult topics.

Day 5
• Test yourself without looking at the notes.

Day 6
• Correct mistakes and revise weak areas.

Day 7
• Complete a final revision.
""";
  }
}