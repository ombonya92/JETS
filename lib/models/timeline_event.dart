class TimelineEvent {
  final String title;
  final String description;
  final DateTime date;
  final bool completed;

  const TimelineEvent({
    required this.title,
    required this.description,
    required this.date,
    required this.completed,
  });
}