import 'package:talker_flutter/talker_flutter.dart';

/// Global Talker instance for logging.
///
/// In a senior architecture, you use this instead of `print()`.
/// Example:
/// ```dart
/// talker.info('Something happened');
/// talker.handle(exception, stackTrace);
/// ```
final talker = TalkerFlutter.init(
  settings: TalkerSettings(
    maxHistoryItems: 500,
    useConsoleLogs: true,
  ),
);
