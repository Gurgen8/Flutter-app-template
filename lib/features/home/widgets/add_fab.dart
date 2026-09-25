import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Animated floating action button with press-scale feedback.
class AddFab extends StatefulWidget {
  const AddFab({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<AddFab> createState() => _AddFabState();
}

class _AddFabState extends State<AddFab> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scale = Tween<double>(begin: 1, end: 0.91).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: AppTheme.avatarGradient,
              borderRadius: BorderRadius.circular(22),
              boxShadow: AppTheme.primaryShadow(0.45),
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      );
}
