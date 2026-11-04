class StudyTask {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool completed;
  final String category;

  const StudyTask({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.completed = false,
    this.category = 'Task',
  });

  factory StudyTask.fromJson(Map<String, dynamic> json) {
    return StudyTask(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      completed: (json['completed'] as bool?) ?? false,
      category: (json['category'] as String?) ?? 'Task',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'completed': completed,
      'category': category,
    };
  }

  StudyTask copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    bool? completed,
    String? category,
  }) {
    return StudyTask(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
      category: category ?? this.category,
    );
  }
}