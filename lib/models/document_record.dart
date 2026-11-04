class DocumentRecord {
  final String id;
  final String fileName;
  final int pageCount;
  final List<String> subjects;
  final List<String> keywords;
  final DateTime uploadedAt;
  final List<String> tags;

  const DocumentRecord({
    required this.id,
    required this.fileName,
    required this.pageCount,
    required this.subjects,
    required this.keywords,
    required this.uploadedAt,
    List<String>? tags,
  }) : tags = tags ?? const [];

  factory DocumentRecord.fromJson(Map<String, dynamic> json) {
    return DocumentRecord(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      pageCount: (json['pageCount'] as int?) ?? 0,
      subjects: List<String>.from(json['subjects'] as List? ?? []),
      keywords: List<String>.from(json['keywords'] as List? ?? []),
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      tags: List<String>.from(json['tags'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'pageCount': pageCount,
      'subjects': subjects,
      'keywords': keywords,
      'uploadedAt': uploadedAt.toIso8601String(),
      'tags': tags,
    };
  }

  DocumentRecord copyWith({
    String? fileName,
    List<String>? tags,
  }) {
    return DocumentRecord(
      id: id,
      fileName: fileName ?? this.fileName,
      pageCount: pageCount,
      subjects: subjects,
      keywords: keywords,
      uploadedAt: uploadedAt,
      tags: tags ?? List<String>.from(this.tags),
    );
  }
}