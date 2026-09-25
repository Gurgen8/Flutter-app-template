import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/core/theme/app_theme.dart';
import 'package:flutter_app/features/home/home.dart';

// ─── Helper ───────────────────────────────────────────────────────────────────

/// Оборачивает виджет в ProviderScope + MaterialApp с нашей темой.
Widget makeTestable(Widget child) => ProviderScope(
      child: MaterialApp(
        theme: AppTheme.dark,
        home: child,
      ),
    );

// ─── Task model tests ─────────────────────────────────────────────────────────

void main() {
  group('Task model', () {
    test('создаётся с isDone = false по умолчанию', () {
      final task = Task(
        id: '1',
        title: 'Тест',
        createdAt: DateTime.now(),
      );
      expect(task.isDone, isFalse);
    });

    test('copyWith меняет только указанные поля', () {
      final task = Task(id: '1', title: 'Исходная', createdAt: DateTime.now());
      final updated = task.copyWith(isDone: true);

      expect(updated.isDone, isTrue);
      expect(updated.title, equals('Исходная'));
      expect(updated.id, equals('1'));
    });

    test('equality работает по id и isDone', () {
      final t1 = Task(id: '1', title: 'A', createdAt: DateTime.now());
      final t2 = Task(id: '1', title: 'B', createdAt: DateTime.now());
      expect(t1, equals(t2)); // одинаковый id и isDone
    });
  });

  // ─── Provider tests ─────────────────────────────────────────────────────────

  group('TasksNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('начальный список содержит 3 задачи', () {
      final tasks = container.read(tasksProvider);
      expect(tasks.length, equals(3));
    });

    test('add() добавляет задачу в список', () {
      container.read(tasksProvider.notifier).add('Новая задача');
      expect(container.read(tasksProvider).length, equals(4));
      expect(
        container.read(tasksProvider).last.title,
        equals('Новая задача'),
      );
    });

    test('toggle() меняет isDone у задачи', () {
      final id = container.read(tasksProvider).first.id;
      container.read(tasksProvider.notifier).toggle(id);
      final task = container.read(tasksProvider).first;
      expect(task.isDone, isTrue);
    });

    test('remove() удаляет задачу по id', () {
      final id = container.read(tasksProvider).first.id;
      container.read(tasksProvider.notifier).remove(id);
      expect(container.read(tasksProvider).length, equals(2));
      expect(
        container.read(tasksProvider).any((t) => t.id == id),
        isFalse,
      );
    });

    test('completedCountProvider считает выполненные', () {
      final id = container.read(tasksProvider).first.id;
      container.read(tasksProvider.notifier).toggle(id);
      expect(container.read(completedCountProvider), equals(1));
    });

    test('progressProvider возвращает 0 при пустом списке', () {
      // Удаляем все задачи
      final ids = container.read(tasksProvider).map((t) => t.id).toList();
      for (final id in ids) {
        container.read(tasksProvider.notifier).remove(id);
      }
      expect(container.read(progressProvider), equals(0.0));
    });
  });

  // ─── Widget tests ────────────────────────────────────────────────────────────

  group('HomeScreen widget', () {
    testWidgets('отображает заголовок "Мои задачи"', (tester) async {
      await tester.pumpWidget(makeTestable(const HomeScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Мои задачи'), findsOneWidget);
    });

    testWidgets('отображает список задач', (tester) async {
      await tester.pumpWidget(makeTestable(const HomeScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Изучить Riverpod'), findsOneWidget);
    });

    testWidgets('отображает FAB кнопку добавления', (tester) async {
      await tester.pumpWidget(makeTestable(const HomeScreen()));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    });
  });
}
