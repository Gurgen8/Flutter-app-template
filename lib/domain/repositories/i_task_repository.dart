import 'package:flutter_app/domain/models/task.dart';

/// Abstract contract for task persistence.
///
/// The domain layer defines WHAT must be done.
/// The data layer decides HOW it is done (local DB, API, cache…).
///
/// This inversion allows swapping implementations without touching
/// any business logic or UI code.
abstract interface class ITaskRepository {
  /// Returns all tasks, ordered by [Task.createdAt] descending.
  Future<List<Task>> getAll();

  /// Persists a new [task]. Throws [StorageException] on failure.
  Future<void> add(Task task);

  /// Replaces the stored task with the same [Task.id].
  /// Throws [TaskNotFoundException] if the id does not exist.
  Future<void> update(Task task);

  /// Removes the task with the given [id].
  /// Throws [TaskNotFoundException] if the id does not exist.
  Future<void> delete(String id);
}
