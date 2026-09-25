# 📱 Flutter Tasks App

> Современное мобильное приложение для управления задачами, написанное на **Flutter** с применением **senior-level архитектуры**.

---

## 📋 О проекте

**Flutter Tasks App** — это учебно-демонстрационный проект, показывающий как правильно строить Flutter-приложения по принципам чистой архитектуры. Проект создан как эталонная реализация для разработчиков, которые хотят понять как организовывать код в больших масштабируемых Flutter-приложениях.

### Что умеет приложение:
- ✅ Просмотр списка задач
- ➕ Добавление новых задач через bottom sheet
- ☑️ Отметка задач как выполненных (с анимацией)
- 🗑️ Удаление задач свайпом вправо-влево
- 📊 Отображение прогресса выполнения в реальном времени
- 👤 Экран профиля со статистикой
- 🌙 Красивая тёмная тема с кастомной палитрой

---

## 🏗️ Архитектура

Проект использует **Feature-based Clean Architecture** — каждая фича изолирована и содержит все свои слои внутри.

### Принципы которые соблюдаются:

| Принцип | Описание |
|---------|---------|
| **Single Responsibility** | Каждый файл и класс делает ровно одну вещь |
| **Separation of Concerns** | UI не знает о бизнес-логике, провайдеры не знают об UI |
| **DRY** | Градиенты, тени, отступы определены один раз в `AppTheme` |
| **Composition over Inheritance** | Виджеты собираются из маленьких кусков |
| **Immutability** | Модели данных иммутабельны, состояние меняется только через Notifier |

---

## 📁 Структура проекта

```
lib/
├── core/                                  # Общие компоненты для всего приложения
│   ├── extensions/
│   │   └── build_context_ext.dart         # Расширения для BuildContext
│   └── theme/
│       └── app_theme.dart                 # Дизайн-система: цвета, типографика, тени
│
├── features/                              # Фичи приложения (feature-based структура)
│   │
│   ├── home/                              # Фича "Главный экран"
│   │   ├── home.dart                      # Barrel export — единая точка импорта
│   │   ├── models/
│   │   │   └── task.dart                  # Доменная модель Task (иммутабельная)
│   │   ├── providers/
│   │   │   └── tasks_provider.dart        # Riverpod Notifier + 4 провайдера
│   │   ├── screens/
│   │   │   └── home_screen.dart           # Экран — только компоновка виджетов
│   │   └── widgets/                       # Переиспользуемые виджеты фичи
│   │       ├── add_fab.dart               # Кнопка "+" с анимацией нажатия
│   │       ├── add_task_sheet.dart        # Bottom sheet добавления задачи
│   │       ├── home_header.dart           # Шапка: приветствие + аватар
│   │       ├── progress_card.dart         # Карточка прогресса с анимацией
│   │       └── task_card.dart             # Строка задачи (свайп, чекбокс)
│   │
│   └── profile/                           # Фича "Профиль"
│       ├── profile.dart                   # Barrel export
│       ├── screens/
│       │   └── profile_screen.dart        # Экран профиля
│       └── widgets/
│           ├── menu_item_tile.dart        # Строка настроек меню
│           └── stat_card.dart             # Карточка статистики
│
└── main.dart                              # Точка входа (30 строк)
```

---

## 🛠️ Технологический стек

| Технология | Версия | Назначение |
|-----------|--------|-----------|
| **Flutter** | 3.x | UI фреймворк |
| **Dart** | 3.x | Язык программирования |
| **flutter_riverpod** | ^2.6.1 | State management |
| **google_fonts** | ^6.2.1 | Типографика (шрифт Inter) |

---

## 🧠 State Management — Riverpod

Для управления состоянием используется **Riverpod 2.x** — современный и рекомендуемый подход в Flutter.

### Как устроены провайдеры:

```dart
// Главный провайдер — список задач
final tasksProvider = NotifierProvider<TasksNotifier, List<Task>>(
  TasksNotifier.new,
);

// Вычисляемые провайдеры (автоматически пересчитываются)
final completedCountProvider = Provider<int>(
  (ref) => ref.watch(tasksProvider).where((t) => t.isDone).length,
);

final progressProvider = Provider<double>((ref) {
  final total = ref.watch(totalCountProvider);
  final completed = ref.watch(completedCountProvider);
  return total == 0 ? 0.0 : completed / total;
});
```

### Поток данных:
```
Пользователь нажимает → TaskCard → ref.read(tasksProvider.notifier).toggle(id)
                                                    ↓
                                           TasksNotifier.toggle()
                                                    ↓
                                         state обновляется
                                                    ↓
                   HomeScreen, ProgressCard, ProfileScreen — всё пересчитывается автоматически
```

---

## 🎨 Дизайн-система

Вся палитра и стили определены в одном месте — [`lib/core/theme/app_theme.dart`](lib/core/theme/app_theme.dart):

```dart
abstract final class AppTheme {
  static const primary     = Color(0xFF6C63FF);  // Фиолетовый — основной
  static const secondary   = Color(0xFFFF6584);  // Розовый — акцент
  static const accent      = Color(0xFF43E97B);  // Зелёный — успех
  static const bgDark      = Color(0xFF0F0F1A);  // Фон приложения
  static const bgCard      = Color(0xFF1A1A2E);  // Фон карточек
  static const textPrimary = Color(0xFFF5F5FF);  // Основной текст
}
```

Использование расширений контекста вместо `Theme.of(context)`:
```dart
// ❌ Многословно
Theme.of(context).textTheme.titleLarge

// ✅ Через extension
context.textTheme.titleLarge
```

---

## 🚀 Как запустить

### Требования

- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.x
- [Android Studio](https://developer.android.com/studio) или [Xcode](https://developer.apple.com/xcode/) (для iOS)
- Эмулятор или реальное устройство

### 1. Клонируй и установи зависимости

```bash
# Установить пакеты
flutter pub get
```

### 2. Запуск

```bash
# Посмотреть доступные устройства
flutter devices

# Запуск на Android эмуляторе
yarn android:emulator

# Запуск на Android устройстве
yarn android

# Запуск на iOS симуляторе
flutter run -d 58E85CB0-70A1-4538-84E3-FCCBBE08E0F9

# Запуск на macOS (desktop)
flutter run -d macos
```

### 3. Через Xcode (iOS)

```bash
# 1. Установить CocoaPods зависимости
cd ios && pod install

# 2. Открыть в Xcode (обязательно .xcworkspace, не .xcodeproj!)
open ios/Runner.xcworkspace

# 3. В Xcode выбрать устройство и нажать ▶️ Run
```

> ⚠️ **Важно**: для запуска на реальном iPhone нужно в Xcode → Signing & Capabilities → выбрать свой Apple Team.

---

## ⚡ Hot Reload и Hot Restart

Когда приложение запущено через `flutter run`:

```
r → Hot Reload   (применяет изменения UI за < 1 сек, состояние сохраняется)
R → Hot Restart  (полный перезапуск, нужен после добавления новых пакетов)
q → Выйти
```

В VS Code — просто нажми **Cmd+S** и изменение применится автоматически.

---

## 🧪 Полезные команды

```bash
# Статический анализ кода
flutter analyze

# Запустить тесты
flutter test

# Очистить билд кэш
flutter clean && flutter pub get

# Сборка APK для Android
flutter build apk

# Сборка для iOS
flutter build ios

# Посмотреть все устройства
flutter devices

# Посмотреть все эмуляторы
flutter emulators
```

---

## 📖 Как добавить новую фичу

Следуй этой структуре при добавлении нового экрана:

```bash
lib/features/my_feature/
├── my_feature.dart              # Barrel export
├── models/
│   └── my_model.dart            # Доменная модель
├── providers/
│   └── my_provider.dart         # Riverpod провайдеры
├── screens/
│   └── my_screen.dart           # Только компоновка
└── widgets/
    └── my_widget.dart           # Атомарные виджеты
```

Добавь маршрут в `main.dart`:
```dart
routes: {
  '/': (_) => const HomeScreen(),
  '/profile': (_) => const ProfileScreen(),
  '/my-feature': (_) => const MyScreen(), // ← новый маршрут
},
```

---

## 👨‍💻 Автор

**Gurgen Mkrtchyan** — разработан с ❤️ и вниманием к архитектуре.
