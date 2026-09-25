import 'package:flutter_app/core/error/app_exception.dart';
import 'package:flutter_app/data/sources/task_local_source.dart';
import 'package:flutter_app/domain/models/task.dart';
import 'package:flutter_app/domain/repositories/i_task_repository.dart';

/// Concrete implementation of [ITaskRepository] backed by [TaskLocalSource].
///
/// Catches raw exceptions from the data source and re-throws
/// typed [AppException]s — so the domain & feature layers never
/// deal with low-level storage errors.
class TaskRepositoryImpl implements ITaskRepository {
  const TaskRepositoryImpl(this._source);

  final TaskLocalSource _source;

  @override
  Future<List<Task>> getAll() async {
    try {
      final tasks = await _source.fetchAll();
      return List.of(tasks)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      throw StorageException(e.toString());
    }
  }

  @override
  Future<void> add(Task task) async {
    try {
      await _source.insert(task);
    } catch (e) {
      throw StorageException(e.toString());
    }
  }

  @override
  Future<void> update(Task task) async {
    try {
      await _source.save(task);
    } on AppException {
      rethrow; // TaskNotFoundException is already typed — pass through
    } catch (e) {
      throw StorageException(e.toString());
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _source.remove(id);
    } on AppException {
      rethrow;
    } catch (e) {
      throw StorageException(e.toString());
    }
  }
}
