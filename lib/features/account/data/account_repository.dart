import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/database.dart';
import '../../../core/data/mappers.dart';
import '../domain/account.dart';

abstract interface class AccountRepository {
  Stream<Account> watchPrimaryAccount();

  Future<void> updateHolderName(String name);
}

class MockAccountRepository implements AccountRepository {
  MockAccountRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<Account> watchPrimaryAccount() => (_db.select(
    _db.accounts,
  )..limit(1)).watchSingle().map((row) => row.toDomain());

  @override
  Future<void> updateHolderName(String name) async {
    await _db
        .update(_db.accounts)
        .write(AccountsCompanion(holderName: Value(name)));
  }
}

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => MockAccountRepository(ref.watch(databaseProvider)),
);

final primaryAccountProvider = StreamProvider<Account>(
  (ref) => ref.watch(accountRepositoryProvider).watchPrimaryAccount(),
);
