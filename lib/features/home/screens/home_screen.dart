import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/build_context_ext.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/tasks_provider.dart';
import '../widgets/add_fab.dart';
import '../widgets/add_task_sheet.dart';
import '../widgets/home_header.dart';
import '../widgets/progress_card.dart';
import '../widgets/task_card.dart';

/// Home screen — composes widgets, reads providers, owns zero business logic.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final completed = ref.watch(completedCountProvider);
    final total = ref.watch(totalCountProvider);
    final progress = ref.watch(progressProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeader(
                      onAvatarTap: () => context.pushNamed('/profile'),
                    ),
                    const SizedBox(height: 24),
                    ProgressCard(
                      completed: completed,
                      total: total,
                      progress: progress,
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Список задач',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            tasks.isEmpty
                ? const SliverFillRemaining(child: _EmptyState())
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList.separated(
                      itemCount: tasks.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (_, i) => TaskCard(task: tasks[i]),
                    ),
                  ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
      floatingActionButton: AddFab(
        onTap: () => AddTaskSheet.show(context),
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              'Все задачи выполнены!',
              style: context.textTheme.titleMedium
                  ?.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
}
