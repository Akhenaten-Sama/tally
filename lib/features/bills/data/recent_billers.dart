import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/money/money.dart';
import '../../../core/widgets/bill_illustration.dart';
import '../../auth/domain/phone_number.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/bank_transaction.dart';
import '../domain/billers.dart';

const billCategories = {
  TxnCategory.airtime,
  TxnCategory.data,
  TxnCategory.electricity,
  TxnCategory.cable,
};

/// What a bill screen should be filled in with, e.g. from "Pay again".
@immutable
class BillPrefill {
  const BillPrefill({
    this.data = false,
    this.phone,
    this.network,
    this.amount,
    this.disco,
    this.meterType,
    this.meterNumber,
    this.cableProvider,
    this.smartcard,
  });

  /// For airtime screens: open on the Data tab.
  final bool data;
  final PhoneNumber? phone;
  final MobileNetwork? network;
  final Money? amount;
  final Disco? disco;
  final MeterType? meterType;
  final String? meterNumber;
  final CableProvider? cableProvider;
  final String? smartcard;

  /// Rebuilds the inputs of a past bill payment from its transaction.
  static BillPrefill? fromTransaction(BankTransaction t) {
    final account = t.counterpartyAccount;
    if (account == null) return null;
    return switch (t.category) {
      TxnCategory.airtime || TxnCategory.data => BillPrefill(
        data: t.category == TxnCategory.data,
        phone: PhoneNumber.tryParse(account),
        network: _network(t.counterpartyName),
        amount: t.category == TxnCategory.airtime ? t.amount : null,
      ),
      TxnCategory.electricity => BillPrefill(
        disco: Disco.values.firstWhereOrNull(
          (d) => t.counterpartyName.startsWith(d.name),
        ),
        meterType: t.counterpartyName.contains('Postpaid')
            ? MeterType.postpaid
            : MeterType.prepaid,
        meterNumber: account,
        amount: t.amount,
      ),
      TxnCategory.cable => BillPrefill(
        cableProvider: CableProvider.values.firstWhereOrNull(
          (p) => t.counterpartyName.startsWith(p.label),
        ),
        smartcard: account,
      ),
      _ => null,
    };
  }

  static MobileNetwork? _network(String counterparty) => MobileNetwork.values
      .firstWhereOrNull((n) => counterparty.startsWith(n.label));
}

@immutable
class SavedBiller {
  const SavedBiller({
    required this.title,
    required this.subtitle,
    required this.prefill,
    this.network,
    this.art,
  });

  final String title;
  final String subtitle;
  final BillPrefill prefill;

  /// Shown as the avatar for phone numbers instead of initials.
  final MobileNetwork? network;

  /// Small illustration avatar for meters and smartcards.
  final BillArt? art;
}

final _billTransactionsProvider = Provider<List<BankTransaction>>(
  (ref) => [
    for (final t
        in ref.watch(allTransactionsProvider).value ??
            const <BankTransaction>[])
      if (billCategories.contains(t.category) && t.status != TxnStatus.failed)
        t,
  ],
);

final recentBillPaymentsProvider = Provider<List<BankTransaction>>(
  (ref) => ref.watch(_billTransactionsProvider).take(5).toList(),
);

/// Total paid for bills this calendar month, and how many payments.
final billsThisMonthProvider = Provider<(Money, int)>((ref) {
  final now = DateTime.now();
  final month = ref
      .watch(_billTransactionsProvider)
      .where(
        (t) =>
            t.createdAt.year == now.year &&
            t.createdAt.month == now.month &&
            t.status != TxnStatus.reversed,
      )
      .toList();
  return (month.fold(const Money.zero(), (s, t) => s + t.amount), month.length);
});

List<SavedBiller> _distinct(
  List<BankTransaction> transactions,
  bool Function(BankTransaction) include,
  SavedBiller Function(BankTransaction, BillPrefill) build,
) {
  final seen = <String>{};
  return [
    for (final t in transactions)
      if (include(t) && seen.add(t.counterpartyAccount ?? ''))
        if (BillPrefill.fromTransaction(t) case final prefill?)
          build(t, prefill),
  ].take(6).toList();
}

final recentPhonesProvider = Provider<List<SavedBiller>>(
  (ref) => _distinct(
    ref.watch(_billTransactionsProvider),
    (t) => t.category == TxnCategory.airtime || t.category == TxnCategory.data,
    (t, p) => SavedBiller(
      title: p.phone?.display ?? t.counterpartyAccount!,
      subtitle: p.network?.label ?? '',
      prefill: p,
      network: p.network,
    ),
  ),
);

final recentMetersProvider = Provider<List<SavedBiller>>(
  (ref) => _distinct(
    ref.watch(_billTransactionsProvider),
    (t) => t.category == TxnCategory.electricity,
    (t, p) => SavedBiller(
      // The customer's name when we have it from the meter lookup.
      title: t.counterpartyBank ?? p.disco?.name ?? 'Meter',
      subtitle: '${p.disco?.code ?? ''} · ${t.counterpartyAccount}',
      prefill: p,
      art: BillArt.electricity,
    ),
  ),
);

final recentSmartcardsProvider = Provider<List<SavedBiller>>(
  (ref) => _distinct(
    ref.watch(_billTransactionsProvider),
    (t) => t.category == TxnCategory.cable,
    (t, p) => SavedBiller(
      title: t.counterpartyBank ?? t.counterpartyName,
      subtitle: '${p.cableProvider?.label ?? ''} · ${t.counterpartyAccount}',
      prefill: p,
      art: BillArt.cable,
    ),
  ),
);
