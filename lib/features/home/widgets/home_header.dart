import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/extensions/build_context_ext.dart';

/// Top header row: greeting + title + avatar button.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.onAvatarTap});

  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Greeting(context: context),
          _AvatarButton(onTap: onAvatarTap),
        ],
      );
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Привет 👋',
            style: context.textTheme.bodyMedium
                ?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            'Мои задачи',
            style: context.textTheme.headlineMedium,
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
