import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/extensions/build_context_ext.dart';

/// Data class for a single settings menu entry.
class MenuItemData {
  const MenuItemData({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback? onTap;
}

/// Tappable settings row with icon, label, subtitle, and chevron.
class MenuItemTile extends StatelessWidget {
  const MenuItemTile({super.key, required this.item});

  final MenuItemData item;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: item.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              child: Row(
                children: [
                  _IconBox(icon: item.icon),
                  const SizedBox(width: 16),
                  Expanded(child: _Labels(item: item, context: context)),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppTheme.primary, size: 22),
      );
}

class _Labels extends StatelessWidget {
  const _Labels({required this.item, required this.context});
  final MenuItemData item;
  final BuildContext context;

  @override
  Widget build(BuildContext _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.label,
            style: context.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(item.subtitle, style: context.textTheme.bodySmall),
        ],
      );
}
