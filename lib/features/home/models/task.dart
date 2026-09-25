/// Immutable domain model representing a single task.
class Task {
  const Task({
    required this.id,
    required this.title,
    this.isDone = false,
    required this.createdAt,
  });

  final String id;
  final String title;
  final bool isDone;
  final DateTime createdAt;

  Task copyWith({String? title, bool? isDone}) => Task(
        id: id,
        title: title ?? this.title,
        isDone: isDone ?? this.isDone,
        createdAt: createdAt,
      );

  @override
  bool operator ==(Object other) =>
      other is Task && other.id == id && other.isDone == isDone;

  @override
  int get hashCode => Object.hash(id, isDone);
}
