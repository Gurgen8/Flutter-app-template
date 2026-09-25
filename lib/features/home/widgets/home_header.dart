import 'package:flutter/material.dart';
import 'package:flutter_app/core/theme/app_theme.dart';

/// Top header row: greeting + title + avatar button.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.onAvatarTap});

  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Greeting(),
          _AvatarButton(onTap: onAvatarTap),
        ],
      );
}

// ─── Private sub-widgets ──────────────────────────────────────────────────────

class _Greeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Привет 👋',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            'Мои задачи',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      );
}

class _AvatarButton extends StatelessWidget {
  const _AvatarButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppTheme.avatarGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.person_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      );
}
