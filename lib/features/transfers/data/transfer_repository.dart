import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/database.dart';
import '../../../core/data/mock_ledger.dart';
import '../../../core/lookups/lookup_providers.dart';
import '../../../core/network/mock_network.dart';
import '../../transactions/domain/bank_transaction.dart';
import '../domain/bank.dart';
import '../domain/transfer.dart';
import 'mock_transfer_repository.dart';

abstract interface class TransferRepository {
  /// Name enquiry: who owns this account? Shown before the user confirms.
  Future<String> resolveAccountName({
    required Bank bank,
    required String accountNumber,
  });

  /// Debits the account and submits the transfer. Idempotent on
  /// [TransferRequest.reference]. The result may still be pending.
  Future<BankTransaction> send(TransferRequest request);

  /// Settles transfers left pending, e.g. when the app was killed mid-flight.
  Future<void> reconcilePending();

  Stream<List<Beneficiary>> watchBeneficiaries();
}

final transferRepositoryProvider = Provider<TransferRepository>((ref) {
  final repository = MockTransferRepository(
    ref.watch(databaseProvider),
    ref.watch(mockNetworkProvider),
    ledger: ref.watch(mockLedgerProvider),
    liveNameEnquiry: ref.watch(paystackNameEnquiryProvider),
  );
  ref.onDispose(repository.dispose);
  return repository;
});

final beneficiariesProvider = StreamProvider<List<Beneficiary>>(
  (ref) => ref.watch(transferRepositoryProvider).watchBeneficiaries(),
);
