import 'package:flutter/material.dart';
import 'package:flutter_app/core/theme/app_theme.dart';
import 'package:flutter_app/features/profile/widgets/stat_card.dart';

/// Stats row showing completed / total / remaining task counts.
class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({
    super.key,
    required this.completed,
    required this.total,
  });

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
