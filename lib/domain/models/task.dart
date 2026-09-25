/// Pure domain model — no Flutter, no Riverpod, no JSON dependencies.
///
/// Immutable by design: all mutations return a new instance via [copyWith].
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.createdAt,
    this.isDone = false,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final bool isDone;

  Task copyWith({String? title, bool? isDone}) => Task(
        id: id,
        title: title ?? this.title,
        createdAt: createdAt,
        isDone: isDone ?? this.isDone,
      );

  @override
  bool operator ==(Object other) =>
      other is Task && other.id == id && other.isDone == isDone;

  @override
  int get hashCode => Object.hash(id, isDone);

  @override
  String toString() => 'Task(id: $id, title: $title, isDone: $isDone)';
}
