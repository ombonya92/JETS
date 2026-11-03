class TimelineEvent {
  final DateTime time;
  final String title;
  final String description;
  final String category;

  const TimelineEvent({
    required this.time,
    required this.title,
    required this.description,
    required this.category,
  });

  factory TimelineEvent.fromJson(Map<String, dynamic> json) {
    return TimelineEvent(
      time: DateTime.parse(json['time'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'title': title,
      'description': description,
      'category': category,
    };
  }
}