import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/database.dart';
import '../../../core/data/mappers.dart';
import '../domain/bank_transaction.dart';

abstract interface class TransactionRepository {
  Stream<List<BankTransaction>> watchTransactions({int? limit});

  Stream<BankTransaction> watchTransaction(String id);
}

class MockTransactionRepository implements TransactionRepository {
  MockTransactionRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<BankTransaction>> watchTransactions({int? limit}) {
    final query = _db.select(_db.transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    if (limit != null) query.limit(limit);
    return query.watch().map((rows) => [for (final r in rows) r.toDomain()]);
  }

  @override
  Stream<BankTransaction> watchTransaction(String id) => (_db.select(
    _db.transactions,
  )..where((t) => t.id.equals(id))).watchSingle().map((row) => row.toDomain());
}

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => MockTransactionRepository(ref.watch(databaseProvider)),
);

final recentTransactionsProvider = StreamProvider<List<BankTransaction>>(
  (ref) => ref.watch(transactionRepositoryProvider).watchTransactions(limit: 5),
);

final allTransactionsProvider = StreamProvider<List<BankTransaction>>(
  (ref) => ref.watch(transactionRepositoryProvider).watchTransactions(),
);

/// Live, so a pending transfer updates on screen the moment it settles.
final transactionProvider = StreamProvider.autoDispose
    .family<BankTransaction, String>(
      (ref, id) =>
          ref.watch(transactionRepositoryProvider).watchTransaction(id),
    );
