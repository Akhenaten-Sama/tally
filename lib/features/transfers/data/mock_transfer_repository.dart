import 'package:drift/drift.dart';

import '../../../core/data/database.dart';
import '../../../core/data/mappers.dart';
import '../../../core/data/mock_ledger.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/lookups/paystack_name_enquiry.dart';
import '../../../core/network/mock_network.dart';
import '../../transactions/domain/bank_transaction.dart';
import '../domain/bank.dart';
import '../domain/transfer.dart';
import 'mock_directory.dart';
import 'transfer_repository.dart';

/// Transfers on top of [MockLedger]: name enquiry, NIP fees and saved
/// beneficiaries. Debit, settlement and reversal live in the ledger.
class MockTransferRepository implements TransferRepository {
  MockTransferRepository(
    this._db,
    this._network, {
    MockLedger? ledger,
    this._liveNameEnquiry,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now,
       _ownsLedger = ledger == null,
       _ledger = ledger ?? MockLedger(_db, _network, clock: clock);

  final AppDatabase _db;
  final MockNetwork _network;
  final MockLedger _ledger;
  final bool _ownsLedger;

  /// Real lookups for other banks when a Paystack key is configured.
  final PaystackNameEnquiry? _liveNameEnquiry;
  final DateTime Function() _clock;

  @override
  Future<String> resolveAccountName({
    required Bank bank,
    required String accountNumber,
  }) async {
    if (!RegExp(r'^\d{10}$').hasMatch(accountNumber)) {
      throw const ValidationException('Account number must be 10 digits.');
    }
    final live = _liveNameEnquiry;
    if (live != null && !bank.isInternal) {
      return live.resolve(bankCode: bank.code, accountNumber: accountNumber);
    }
    await _network.roundTrip();
    return mockAccountName(bank, accountNumber);
  }

  @override
  Future<BankTransaction> send(TransferRequest request) => _ledger.pay(
    LedgerDebit(
      reference: request.reference,
      category: TxnCategory.transfer,
      amount: request.amount,
      fee: transferFee(request.amount, bank: request.bank),
      narration: request.narration,
      counterpartyName: request.accountName,
      counterpartyAccount: request.accountNumber,
      counterpartyBank: request.bank.name,
    ),
    beforeSettle: () => _saveBeneficiary(request),
  );

  @override
  Future<void> reconcilePending() => _ledger.reconcilePending();

  @override
  Stream<List<Beneficiary>> watchBeneficiaries() =>
      (_db.select(_db.beneficiaries)
            ..orderBy([(b) => OrderingTerm.desc(b.lastUsedAt)]))
          .watch()
          .map((rows) => [for (final r in rows) r.toDomain()]);

  void dispose() {
    if (_ownsLedger) _ledger.dispose();
  }

  Future<void> _saveBeneficiary(TransferRequest request) async {
    await _db
        .into(_db.beneficiaries)
        .insertOnConflictUpdate(
          BeneficiariesCompanion.insert(
            bankCode: request.bank.code,
            accountNumber: request.accountNumber,
            name: request.accountName,
            lastUsedAt: _clock(),
          ),
        );
  }
}
