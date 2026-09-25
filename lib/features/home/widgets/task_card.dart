import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/core/extensions/build_context_ext.dart';
import 'package:flutter_app/core/theme/app_theme.dart';
import 'package:flutter_app/features/home/providers/tasks_provider.dart';

// ─── Per-task provider (granular rebuild) ─────────────────────────────────────

/// Derived provider scoped to a single task by [id].
/// Only this card rebuilds when its own task changes — not the whole list.
final _taskByIdProvider = Provider.family<Task?, String>(
  (ref, id) => ref.watch(
    tasksProvider.select(
      (asyncValue) => asyncValue.valueOrNull?.firstWhere(
        (t) => t.id == id,
        orElse: () => Task(id: id, title: '', createdAt: DateTime.now()),
      ),
    ),
  ),
);

// ─── Public widget ────────────────────────────────────────────────────────────

/// Swipeable task row.
///
/// Accepts only [taskId] — reads its own state via [_taskByIdProvider]
/// so only this card rebuilds when this specific task changes.
class TaskCard extends ConsumerWidget {
  const TaskCard({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(_taskByIdProvider(taskId));
    if (task == null) return const SizedBox.shrink();

    return RepaintBoundary(
      child: Dismissible(
        key: ValueKey(taskId),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => ref.read(tasksProvider.notifier).remove(taskId),
        background: const _DismissBackground(),
        child: _TaskTile(task: task, taskId: taskId),
      ),
    );
  }
}

// ─── Private sub-widgets ──────────────────────────────────────────────────────

class _DismissBackground extends StatelessWidget {
  const _DismissBackground();

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: AppTheme.secondary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppTheme.secondary,
        ),
      );
}

class _TaskTile extends ConsumerWidget {
  const _TaskTile({required this.task, required this.taskId});

  final Task task;
  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: task.isDone
              ? AppTheme.bgCardLight.withValues(alpha: 0.5)
              : AppTheme.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: task.isDone
                ? AppTheme.accent.withValues(alpha: 0.3)
                : AppTheme.bgCardLight,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            _Checkbox(
              isDone: task.isDone,
              onTap: () => ref.read(tasksProvider.notifier).toggle(taskId),
            ),
            const SizedBox(width: 16),
            Expanded(child: _Label(task: task)),
          ],
        ),
      );
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({required this.isDone, required this.onTap});

  final bool isDone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: isDone ? AppTheme.accent : Colors.transparent,
            border: Border.all(
              color: isDone ? AppTheme.accent : AppTheme.textSecondary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: isDone
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
              : null,
        ),
      );
}

class _Label extends StatelessWidget {
  const _Label({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) => Text(
        task.title,
        style: context.textTheme.bodyLarge?.copyWith(
          color: task.isDone ? AppTheme.textSecondary : AppTheme.textPrimary,
          decoration: task.isDone ? TextDecoration.lineThrough : null,
          decorationColor: AppTheme.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      );
}
