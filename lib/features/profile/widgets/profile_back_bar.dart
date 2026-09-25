import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/core/theme/app_theme.dart';

/// Back navigation bar with title.
class ProfileBackBar extends StatelessWidget {
  const ProfileBackBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          _BackButton(),
          const SizedBox(width: 16),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      );
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.pop(),
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
      );
}
