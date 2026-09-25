import 'package:flutter_app/core/error/app_exception.dart';
import 'package:flutter_app/domain/models/task.dart';

/// In-memory task data source.
///
/// Acts as the single source of truth for the current session.
/// Replace with a SQLite / Hive / HTTP source without changing
/// anything above this layer.
class TaskLocalSource {
  TaskLocalSource() : _store = _defaultTasks();

  final List<Task> _store;

  static List<Task> _defaultTasks() => [
        Task(id: '1', title: 'Изучить Riverpod', createdAt: DateTime.now()),
        Task(id: '2', title: 'Настроить архитектуру', createdAt: DateTime.now()),
        Task(id: '3', title: 'Написать тесты', createdAt: DateTime.now()),
      ];

  Future<List<Task>> fetchAll() async {
    // Simulates async I/O latency (remove in production with real DB)
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_store);
  }

  Future<void> insert(Task task) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _store.add(task);
  }

  Future<void> save(Task task) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _store.indexWhere((t) => t.id == task.id);
    if (index == -1) throw TaskNotFoundException(task.id);
    _store[index] = task;
  }

  Future<void> remove(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final exists = _store.any((t) => t.id == id);
    if (!exists) throw TaskNotFoundException(id);
    _store.removeWhere((t) => t.id == id);
  }
}
