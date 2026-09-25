import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/core/router/app_router.dart';
import 'package:flutter_app/core/theme/app_theme.dart';
import 'package:flutter_app/features/home/providers/tasks_provider.dart';
import 'package:flutter_app/features/profile/providers/profile_provider.dart';
import 'package:flutter_app/features/profile/widgets/menu_item_tile.dart';
import 'package:flutter_app/features/profile/widgets/profile_avatar.dart';
import 'package:flutter_app/features/profile/widgets/profile_back_bar.dart';
import 'package:flutter_app/features/profile/widgets/profile_stats_row.dart';

/// Profile screen — pure composition, zero inline widgets.
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
    final profile = ref.watch(profileProvider);
    final completed = ref.watch(completedCountProvider);
    final total = ref.watch(totalCountProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              const ProfileBackBar(title: 'Профиль'),
              const SizedBox(height: 36),
              ProfileAvatar(
                imageUrl: profile.avatarUrl,
                onEditTap: () {/* TODO: pick image */},
              ),
              const SizedBox(height: 20),
              _UserInfoBlock(name: profile.name, email: profile.email),
              const SizedBox(height: 36),
              RepaintBoundary(
                child: ProfileStatsRow(
                  completed: completed,
                  total: total,
                ),
              ),
              const SizedBox(height: 32),
              
              MenuItemTile(
                item: MenuItemData(
                  icon: Icons.developer_mode_rounded,
                  label: 'DevTools (Логи)',
                  subtitle: 'Просмотр логов и событий',
                  onTap: () => AppRouter.toLogs(context),
                ),
              ),
              
              ..._menuItems.map((item) => MenuItemTile(item: item)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Local-only widget (не переиспользуется вне этого экрана) ─────────────────

class _UserInfoBlock extends StatelessWidget {
  const _UserInfoBlock({required this.name, required this.email});

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      );
}
