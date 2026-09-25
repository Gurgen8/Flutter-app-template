import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';

export '../models/task.dart';

// ─── Notifier ─────────────────────────────────────────────────────────────────

class TasksNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() => [
        Task(id: '1', title: 'Изучить Riverpod', createdAt: DateTime.now()),
        Task(id: '2', title: 'Настроить архитектуру', createdAt: DateTime.now()),
        Task(id: '3', title: 'Написать тесты', createdAt: DateTime.now()),
      ];

  void toggle(String id) {
    state = [
      for (final t in state)
        if (t.id == id) t.copyWith(isDone: !t.isDone) else t,
    ];
  }

  void add(String title) {
    state = [
      ...state,
      Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        createdAt: DateTime.now(),
      ),
    ];
  }

  void remove(String id) {
    state = [for (final t in state) if (t.id != id) t];
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────

final tasksProvider = NotifierProvider<TasksNotifier, List<Task>>(
  TasksNotifier.new,
);

final completedCountProvider = Provider<int>(
  (ref) => ref.watch(tasksProvider).where((t) => t.isDone).length,
);

final totalCountProvider = Provider<int>(
  (ref) => ref.watch(tasksProvider).length,
);

final progressProvider = Provider<double>((ref) {
  final total = ref.watch(totalCountProvider);
  final completed = ref.watch(completedCountProvider);
  return total == 0 ? 0.0 : completed / total;
});
