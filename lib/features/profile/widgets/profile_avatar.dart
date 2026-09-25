import 'package:flutter/material.dart';
import 'package:flutter_app/core/theme/app_theme.dart';

/// Gradient avatar with optional edit badge.
///
/// Shows [imageUrl] if provided, otherwise falls back to a person icon.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.onEditTap,
    this.size = 100,
  });

  final String? imageUrl;
  final VoidCallback? onEditTap;
  final double size;

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.bottomRight,
        children: [
          _AvatarCircle(imageUrl: imageUrl, size: size),
          if (onEditTap != null) _EditBadge(onTap: onEditTap!),
        ],
      );
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.imageUrl, required this.size});

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: AppTheme.avatarGradient,
          borderRadius: BorderRadius.circular(size * 0.32),
          boxShadow: AppTheme.primaryShadow(0.4),
          image: imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imageUrl == null
            ? Icon(Icons.person_rounded,
                size: size * 0.5, color: Colors.white)
            : null,
      );
}

class _EditBadge extends StatelessWidget {
  const _EditBadge({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppTheme.accent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
        ),
      );
}
