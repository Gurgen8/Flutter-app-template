import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/core/extensions/build_context_ext.dart';
import 'package:flutter_app/core/router/app_router.dart';
import 'package:flutter_app/core/theme/app_theme.dart';
import 'package:flutter_app/features/home/providers/tasks_provider.dart';
import 'package:flutter_app/features/home/widgets/add_fab.dart';
import 'package:flutter_app/features/home/widgets/add_task_sheet.dart';
import 'package:flutter_app/features/home/widgets/home_header.dart';
import 'package:flutter_app/features/home/widgets/progress_card.dart';
import 'package:flutter_app/features/home/widgets/task_card.dart';

/// Home screen — handles AsyncValue states, owns zero business logic.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);
    final completed = ref.watch(completedCountProvider);
    final total = ref.watch(totalCountProvider);
    final progress = ref.watch(progressProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          cacheExtent: 200,
          slivers: [
            // ─── Static header (never rebuilds with task changes) ──────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeader(
                      onAvatarTap: () => AppRouter.toProfile(context),
                    ),
                    const SizedBox(height: 24),
                    RepaintBoundary(
                      child: ProgressCard(
                        completed: completed,
                        total: total,
                        progress: progress,
                      ),
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

            // ─── Task list: loading / error / data ─────────────────────────
            tasksAsync.when(
              loading: () => const SliverFillRemaining(
                child: _LoadingState(),
              ),
              error: (error, _) => SliverFillRemaining(
                child: _ErrorState(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(tasksProvider),
                ),
              ),
              data: (tasks) {
                if (tasks.isEmpty) {
                  return const SliverFillRemaining(child: _EmptyState());
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList.separated(
                    itemCount: tasks.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => TaskCard(taskId: tasks[i].id),
                  ),
                );
              },
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
      floatingActionButton: RepaintBoundary(
        child: AddFab(onTap: () => AddTaskSheet.show(context)),
      ),
    );
  }
}

// ─── UI States ────────────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primary,
          strokeWidth: 2,
        ),
      );
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppTheme.secondary,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Что-то пошло не так',
                style: context.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: context.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Повторить'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      );
}

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
