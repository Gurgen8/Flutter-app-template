import 'package:flutter/material.dart';
import 'package:flutter_app/core/extensions/build_context_ext.dart';
import 'package:flutter_app/core/theme/app_theme.dart';

/// Displays progress bar and completion statistics.
class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.completed,
    required this.total,
    required this.progress,
  });

  final int completed;
  final int total;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.primaryShadow(0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildProgressBar(),
          const SizedBox(height: 8),
          _buildSubtitle(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Прогресс',
            style: context.textTheme.titleMedium
                ?.copyWith(color: Colors.white70),
          ),
          Text(
            '$completed / $total',
            style: context.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      );

  Widget _buildProgressBar() => ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: progress),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation(Colors.white),
          ),
        ),
      );

  Widget _buildSubtitle(BuildContext context) => Text(
        '${(progress * 100).toStringAsFixed(0)}% выполнено',
        style: context.textTheme.bodySmall?.copyWith(color: Colors.white70),
      );
}
