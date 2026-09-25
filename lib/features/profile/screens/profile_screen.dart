import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/build_context_ext.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/providers/tasks_provider.dart';
import '../widgets/menu_item_tile.dart';
import '../widgets/stat_card.dart';

/// Profile screen — reads task stats from shared providers.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const _menuItems = [
    MenuItemData(
      icon: Icons.notifications_rounded,
      label: 'Уведомления',
      subtitle: 'Настрой напоминания',
    ),
    MenuItemData(
      icon: Icons.palette_rounded,
      label: 'Тема',
      subtitle: 'Тёмная / Светлая',
    ),
    MenuItemData(
      icon: Icons.lock_outline_rounded,
      label: 'Безопасность',
      subtitle: 'Пароль и Face ID',
    ),
    MenuItemData(
      icon: Icons.info_outline_rounded,
      label: 'О приложении',
      subtitle: 'Версия 1.0.0',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completed = ref.watch(completedCountProvider);
    final total = ref.watch(totalCountProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              _BackBar(),
              const SizedBox(height: 36),
              const _Avatar(),
              const SizedBox(height: 20),
              _UserInfo(context: context),
              const SizedBox(height: 36),
              _StatsRow(completed: completed, total: total),
              const SizedBox(height: 32),
              ..._menuItems.map((item) => MenuItemTile(item: item)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Private sub-widgets ──────────────────────────────────────────────────────

class _BackBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        children: [
          GestureDetector(
            onTap: context.pop,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text('Профиль', style: context.textTheme.titleLarge),
        ],
      );
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: AppTheme.avatarGradient,
              borderRadius: BorderRadius.circular(32),
              boxShadow: AppTheme.primaryShadow(0.4),
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 50,
              color: Colors.white,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.accent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.edit_rounded,
              size: 14,
              color: Colors.white,
            ),
          ),
        ],
      );
}

class _UserInfo extends StatelessWidget {
  const _UserInfo({required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext _) => Column(
        children: [
          Text(
            'Gurgen Mkrtchyan',
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text('gurgen@example.com', style: context.textTheme.bodyMedium),
        ],
      );
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.completed, required this.total});
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          StatCard(
            label: 'Всего',
            value: '$total',
            icon: Icons.task_alt_rounded,
            color: AppTheme.primary,
          ),
          const SizedBox(width: 16),
          StatCard(
            label: 'Выполнено',
            value: '$completed',
            icon: Icons.check_circle_rounded,
            color: AppTheme.accent,
          ),
          const SizedBox(width: 16),
          StatCard(
            label: 'Осталось',
            value: '${total - completed}',
            icon: Icons.pending_rounded,
            color: AppTheme.secondary,
          ),
        ],
      );
}
