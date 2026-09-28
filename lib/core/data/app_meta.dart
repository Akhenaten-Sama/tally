import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';

/// Small persisted app settings (e.g. when notifications were last read),
/// stored in the key-value DemoMeta table.
class AppMeta {
  AppMeta(this._db);

  final AppDatabase _db;

  Stream<String?> watch(String key) =>
      (_db.select(_db.demoMeta)..where((m) => m.key.equals(key)))
          .watchSingleOrNull()
          .map((row) => row?.value);

  Future<void> set(String key, String value) async {
    await _db
        .into(_db.demoMeta)
        .insertOnConflictUpdate(
          DemoMetaCompanion.insert(key: key, value: value),
        );
  }
}

final appMetaProvider = Provider<AppMeta>(
  (ref) => AppMeta(ref.watch(databaseProvider)),
);
