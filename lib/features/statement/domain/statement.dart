import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../../../core/money/money.dart';
import '../../transactions/domain/bank_transaction.dart';

@immutable
class StatementLine {
  const StatementLine({required this.transaction, required this.balance});

  final BankTransaction transaction;

  /// Account balance straight after this transaction.
  final Money balance;

  /// Signed effect on the balance: credits positive, debits negative.
  Money get net => netEffect(transaction);
}

@immutable
class Statement {
  const Statement({
    required this.from,
    required this.to,
    required this.opening,
    required this.closing,
    required this.moneyIn,
    required this.moneyOut,
    required this.lines,
  });

  final DateTime from;
  final DateTime to;
  final Money opening;
  final Money closing;
  final Money moneyIn;
  final Money moneyOut;
  final List<StatementLine> lines;

  /// Works backwards from today's [currentBalance], so the statement always
  /// reconciles with the balance on screen.
  factory Statement.build({
    required List<BankTransaction> transactions,
    required Money currentBalance,
    required DateTime from,
    required DateTime to,
  }) {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day + 1);
    final sorted = transactions
        .where((t) => !netEffect(t).isZero)
        .sortedBy((t) => t.createdAt);

    final afterPeriod = sorted.where((t) => !t.createdAt.isBefore(end));
    final inPeriod = sorted
        .where((t) => !t.createdAt.isBefore(start) && t.createdAt.isBefore(end))
        .toList();

    Money sum(Iterable<BankTransaction> ts) =>
        ts.fold(const Money.zero(), (total, t) => total + netEffect(t));

    final closing = currentBalance - sum(afterPeriod);
    final opening = closing - sum(inPeriod);

    var running = opening;
    final lines = <StatementLine>[];
    var moneyIn = const Money.zero();
    var moneyOut = const Money.zero();
    for (final t in inPeriod) {
      final net = netEffect(t);
      running += net;
      if (net.isNegative) {
        moneyOut += net.abs;
      } else {
        moneyIn += net;
      }
      lines.add(StatementLine(transaction: t, balance: running));
    }

    return Statement(
      from: start,
      to: DateTime(to.year, to.month, to.day),
      opening: opening,
      closing: closing,
      moneyIn: moneyIn,
      moneyOut: moneyOut,
      lines: lines,
    );
  }
}

/// How a transaction moved the balance. A reversed debit still counts:
/// the money left, and its separate reversal credit brought it back.
/// Failed debits never left the account.
Money netEffect(BankTransaction t) {
  if (t.status == TxnStatus.failed) return const Money.zero();
  return t.isCredit ? t.amount : Money(-t.total.kobo);
}
