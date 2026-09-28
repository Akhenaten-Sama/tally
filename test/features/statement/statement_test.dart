import 'package:flutter_test/flutter_test.dart';
import 'package:kora/core/money/money.dart';
import 'package:kora/features/statement/domain/statement.dart';
import 'package:kora/features/transactions/domain/bank_transaction.dart';

BankTransaction txn(
  String id,
  DateTime at,
  int kobo, {
  bool credit = false,
  int fee = 0,
  TxnStatus status = TxnStatus.successful,
  TxnCategory category = TxnCategory.transfer,
}) => BankTransaction(
  id: id,
  reference: id,
  direction: credit ? TxnDirection.credit : TxnDirection.debit,
  category: category,
  status: status,
  amount: Money(kobo),
  fee: Money(fee),
  counterpartyName: 'X',
  createdAt: at,
);

void main() {
  final history = [
    txn('salary', DateTime(2026, 8, 25), 45000000, credit: true),
    txn('rent', DateTime(2026, 9, 2), 20000000, fee: 5375),
    txn('failed', DateTime(2026, 9, 5), 999999, status: TxnStatus.failed),
    // A transfer that bounced: debit then a reversal credit.
    txn(
      'bounced',
      DateTime(2026, 9, 10),
      1000000,
      fee: 2688,
      status: TxnStatus.reversed,
    ),
    txn(
      'refund',
      DateTime(2026, 9, 10, 1),
      1002688,
      credit: true,
      category: TxnCategory.reversal,
    ),
    txn('airtime', DateTime(2026, 9, 20), 50000),
    txn('later', DateTime(2026, 10, 1), 100000),
  ];
  const current = Money(24000000);

  final statement = Statement.build(
    transactions: history,
    currentBalance: current,
    from: DateTime(2026, 9, 1),
    to: DateTime(2026, 9, 30),
  );

  test('closing balance excludes activity after the period', () {
    expect(statement.closing, current + const Money(100000));
  });

  test('opening + in - out = closing', () {
    expect(
      statement.opening + statement.moneyIn - statement.moneyOut,
      statement.closing,
    );
  });

  test('failed payments are left out; reversals show both legs', () {
    final ids = statement.lines.map((l) => l.transaction.id);
    expect(ids, ['rent', 'bounced', 'refund', 'airtime']);
  });

  test('running balance ends at the closing balance', () {
    expect(statement.lines.last.balance, statement.closing);
  });

  test('money out includes fees', () {
    expect(statement.moneyOut, const Money(20005375 + 1002688 + 50000));
  });
}
