// Result of analysing an uploaded document.
class DocumentAnalysis {
  final String fileName;
  final int pageCount;
  final List<String> subjects;
  final List<String> keywords;
  final String summary;
  final String text;

  const DocumentAnalysis({
    required this.fileName,
    required this.pageCount,
    required this.subjects,
    required this.keywords,
    required this.summary,
    required this.text,
  });

  // False for scanned or image-only documents with no extractable text.
  bool get hasText => text.trim().isNotEmpty;
}