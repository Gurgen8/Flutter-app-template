import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/extensions/build_context_ext.dart';
import '../providers/tasks_provider.dart';

/// Swipeable task row with animated checkbox and dismiss-to-delete.
class TaskCard extends ConsumerWidget {
  const TaskCard({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => ref.read(tasksProvider.notifier).remove(task.id),
      background: _DismissBackground(),
      child: _TaskTile(task: task, ref: ref, context: context),
    );
  }
}

// ─── Private sub-widgets ──────────────────────────────────────────────────────

class _DismissBackground extends StatelessWidget {
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

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.ref,
    required this.context,
  });

  final Task task;
  final WidgetRef ref;
  final BuildContext context;

  @override
  Widget build(BuildContext _) => AnimatedContainer(
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
              onTap: () => ref.read(tasksProvider.notifier).toggle(task.id),
            ),
            const SizedBox(width: 16),
            Expanded(child: _Label(task: task, context: context)),
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
  const _Label({required this.task, required this.context});

  final Task task;
  final BuildContext context;

  @override
  Widget build(BuildContext _) => Text(
        task.title,
        style: context.textTheme.bodyLarge?.copyWith(
          color: task.isDone ? AppTheme.textSecondary : AppTheme.textPrimary,
          decoration:
              task.isDone ? TextDecoration.lineThrough : null,
          decorationColor: AppTheme.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      );
}
