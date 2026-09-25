import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/providers/data_providers.dart';
import 'package:flutter_app/domain/models/task.dart';

export 'package:flutter_app/domain/models/task.dart';

// ─── Notifier ─────────────────────────────────────────────────────────────────

/// Manages task list state using [AsyncNotifier].
///
/// Reads from [ITaskRepository] — has no idea whether data comes
/// from SQLite, Hive, or a remote API.
class TasksNotifier extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() => ref.watch(taskRepositoryProvider).getAll();

  Future<void> toggle(String id) async {
    final repo = ref.read(taskRepositoryProvider);
    final current = state.requireValue;
    final task = current.firstWhere((t) => t.id == id);
    final updated = task.copyWith(isDone: !task.isDone);

    // Optimistic update — show change immediately, rollback on error
    state = AsyncData([
      for (final t in current) if (t.id == id) updated else t,
    ]);

    try {
      await repo.update(updated);
    } catch (e, st) {
      // Rollback
      state = AsyncData(current);
      state = AsyncError(e, st);
    }
  }

  Future<void> add(String title) async {
    final repo = ref.read(taskRepositoryProvider);
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      createdAt: DateTime.now(),
    );

    state = AsyncData([task, ...state.requireValue]);

    try {
      await repo.add(task);
    } catch (e, st) {
      state = AsyncData(state.requireValue.where((t) => t.id != task.id).toList());
      state = AsyncError(e, st);
    }
  }

  Future<void> remove(String id) async {
    final repo = ref.read(taskRepositoryProvider);
    final current = state.requireValue;

    state = AsyncData(current.where((t) => t.id != id).toList());

    try {
      await repo.delete(id);
    } catch (e, st) {
      state = AsyncData(current);
      state = AsyncError(e, st);
    }
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────

final tasksProvider = AsyncNotifierProvider<TasksNotifier, List<Task>>(
  TasksNotifier.new,
);

final completedCountProvider = Provider<int>((ref) {
  return ref.watch(tasksProvider).valueOrNull?.where((t) => t.isDone).length ?? 0;
});

final totalCountProvider = Provider<int>((ref) {
  return ref.watch(tasksProvider).valueOrNull?.length ?? 0;
});

final progressProvider = Provider<double>((ref) {
  final total = ref.watch(totalCountProvider);
  final completed = ref.watch(completedCountProvider);
  return total == 0 ? 0.0 : completed / total;
});
