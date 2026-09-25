import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/extensions/build_context_ext.dart';
import '../providers/tasks_provider.dart';

/// Modal bottom sheet for creating a new task.
///
/// Shows via [AddTaskSheet.show] — no need to instantiate directly.
class AddTaskSheet extends ConsumerStatefulWidget {
  const AddTaskSheet({super.key});

  /// Convenience method — opens the sheet imperatively.
  static Future<void> show(BuildContext context) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => const AddTaskSheet(),
      );

  @override
  ConsumerState<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<AddTaskSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref.read(tasksProvider.notifier).add(text);
    context.pop();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(
          24, 24, 24, context.bottomInset + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Новая задача',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _TextField(controller: _controller, onSubmitted: _submit),
            const SizedBox(height: 16),
            _SubmitButton(onTap: _submit),
          ],
        ),
      );
}

// ─── Private sub-widgets ──────────────────────────────────────────────────────

class _TextField extends StatelessWidget {
  const _TextField({required this.controller, required this.onSubmitted});

  final TextEditingController controller;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        autofocus: true,
        style: const TextStyle(color: AppTheme.textPrimary),
        onSubmitted: (_) => onSubmitted(),
        decoration: InputDecoration(
          hintText: 'Введи задачу...',
          hintStyle: const TextStyle(color: AppTheme.textSecondary),
          filled: true,
          fillColor: AppTheme.bgCardLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      );
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Добавить',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
      );
}
