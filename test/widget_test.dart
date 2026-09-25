import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/core/theme/app_theme.dart';
import 'package:flutter_app/features/home/providers/tasks_provider.dart';
import 'package:flutter_app/features/home/screens/home_screen.dart';

// ─── Helper ───────────────────────────────────────────────────────────────────

/// Wraps [child] in ProviderScope + MaterialApp.router for widget tests.
Widget makeTestable(Widget child) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [GoRoute(path: '/', builder: (context, state) => child)],
  );
  return ProviderScope(
    child: MaterialApp.router(
      theme: AppTheme.dark,
      routerConfig: router,
    ),
  );
}

// ─── Task model tests ─────────────────────────────────────────────────────────

void main() {
  group('Task model', () {
    test('создаётся с isDone = false по умолчанию', () {
      final task = Task(id: '1', title: 'Тест', createdAt: DateTime.now());
      expect(task.isDone, isFalse);
    });

    test('copyWith меняет только указанные поля', () {
      final task = Task(id: '1', title: 'Исходная', createdAt: DateTime.now());
      final updated = task.copyWith(isDone: true);
      expect(updated.isDone, isTrue);
      expect(updated.title, equals('Исходная'));
    });

    test('equality работает по id и isDone', () {
      final t1 = Task(id: '1', title: 'A', createdAt: DateTime.now());
      final t2 = Task(id: '1', title: 'B', createdAt: DateTime.now());
      expect(t1, equals(t2));
    });
  });

  // ─── AsyncNotifier tests ──────────────────────────────────────────────────

  group('TasksNotifier (AsyncNotifier)', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() => container.dispose());

    Future<List<Task>> awaitTasks() async {
      // Wait for the async build() to complete
      return await container.read(tasksProvider.future);
    }

    test('начальный список содержит 3 задачи', () async {
      final tasks = await awaitTasks();
      expect(tasks.length, equals(3));
    });

    test('add() добавляет задачу в список', () async {
      await awaitTasks();
      await container.read(tasksProvider.notifier).add('Новая задача');
      final tasks = await awaitTasks();
      expect(tasks.any((t) => t.title == 'Новая задача'), isTrue);
    });

    test('toggle() меняет isDone у задачи', () async {
      final initial = await awaitTasks();
      final id = initial.first.id;
      await container.read(tasksProvider.notifier).toggle(id);
      final updated = container.read(tasksProvider).requireValue;
      final task = updated.firstWhere((t) => t.id == id);
      expect(task.isDone, isTrue);
    });

    test('remove() удаляет задачу по id', () async {
      final initial = await awaitTasks();
      final id = initial.first.id;
      await container.read(tasksProvider.notifier).remove(id);
      final updated = container.read(tasksProvider).requireValue;
      expect(updated.any((t) => t.id == id), isFalse);
    });

    test('completedCountProvider считает выполненные', () async {
      final initial = await awaitTasks();
      await container.read(tasksProvider.notifier).toggle(initial.first.id);
      expect(container.read(completedCountProvider), equals(1));
    });

    test('progressProvider возвращает 0.0 при пустом списке', () async {
      final tasks = await awaitTasks();
      for (final t in tasks) {
        await container.read(tasksProvider.notifier).remove(t.id);
      }
      expect(container.read(progressProvider), equals(0.0));
    });
  });

  // ─── Widget tests ─────────────────────────────────────────────────────────

  group('HomeScreen widget', () {
    testWidgets('после загрузки показывает заголовок', (tester) async {
      await tester.pumpWidget(makeTestable(const HomeScreen()));
      while (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.text('Мои задачи'), findsOneWidget);
    });

    testWidgets('после загрузки показывает задачи', (tester) async {
      await tester.pumpWidget(makeTestable(const HomeScreen()));
      while (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.text('Изучить Riverpod'), findsOneWidget);
    });

    testWidgets('отображает FAB кнопку добавления', (tester) async {
      await tester.pumpWidget(makeTestable(const HomeScreen()));
      while (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    });
  });
}
