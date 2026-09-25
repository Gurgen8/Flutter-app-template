import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/data/repositories/task_repository_impl.dart';
import 'package:flutter_app/data/sources/task_local_source.dart';
import 'package:flutter_app/domain/repositories/i_task_repository.dart';

export 'package:flutter_app/domain/repositories/i_task_repository.dart';

/// Provides the raw data source.
///
/// Override in tests to inject a fake source:
/// ```dart
/// container = ProviderContainer(overrides: [
///   taskLocalSourceProvider.overrideWithValue(FakeTaskSource()),
/// ]);
/// ```
final taskLocalSourceProvider = Provider<TaskLocalSource>(
  (_) => TaskLocalSource(),
);

/// Provides the [ITaskRepository] implementation.
///
/// Features depend only on this interface — never on the concrete class.
final taskRepositoryProvider = Provider<ITaskRepository>(
  (ref) => TaskRepositoryImpl(ref.watch(taskLocalSourceProvider)),
);
