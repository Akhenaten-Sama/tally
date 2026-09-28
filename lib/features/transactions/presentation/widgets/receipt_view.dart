import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/kora_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/bank_transaction.dart';
import 'transaction_tile.dart';
import '../../../../core/brand/brand.dart';
import '../../../../core/brand/brand_logo.dart';

/// The receipt card shown on the details screen and shared as an image.
class ReceiptView extends StatelessWidget {
  const ReceiptView({super.key, required this.transaction});

  final BankTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final kora = context.kora;
    final isTransfer = t.category == TxnCategory.transfer;
    final labels = _labelsFor(t.category);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kora.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kora.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              BrandLogo(height: 44, wordmarkColor: kora.card),
              const Spacer(),
              Text(
                'Transaction receipt',
                style: context.textTheme.labelMedium?.copyWith(
                  color: kora.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '${t.isCredit ? '+' : '−'}${t.amount.format()}',
            textAlign: TextAlign.center,
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontFeatures: amountFeatures,
            ),
          ),
          const SizedBox(height: 8),
          Center(child: StatusPill(status: t.status)),
          const SizedBox(height: 20),
          Divider(color: kora.border),
          const SizedBox(height: 8),
          _Row('Date', formatDateTime(t.createdAt)),
          _Row('Type', t.category.label),
          _Row(
            isTransfer ? (t.isCredit ? 'Sender' : 'Recipient') : 'Details',
            t.counterpartyName,
          ),
          if (t.counterpartyBank != null)
            _Row(labels.bank, t.counterpartyBank!),
          if (t.counterpartyAccount != null)
            _Row(labels.account, t.counterpartyAccount!),
          if (!t.fee.isZero) _Row('Fee', t.fee.format()),
          // A failed purchase's token was never valid, so don't show it.
          if (t.narration.isNotEmpty &&
              !(t.category == TxnCategory.electricity &&
                  t.status != TxnStatus.successful))
            _Row(
              t.category == TxnCategory.electricity &&
                      t.electricityToken == null
                  ? 'Note'
                  : labels.narration,
              t.narration.replaceAll('-', ' '),
            ),
          _Row('Reference', t.reference),
          const SizedBox(height: 16),
          Text(
            'Thank you for banking with ${Brand.current.name}.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(color: kora.muted),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: context.kora.muted)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontFeatures: amountFeatures,
            ),
          ),
        ),
      ],
    ),
  );
}

/// What the generic counterparty fields mean for each kind of transaction.
({String bank, String account, String narration}) _labelsFor(
  TxnCategory category,
) => switch (category) {
  TxnCategory.airtime || TxnCategory.data => (
    bank: 'Provider',
    account: 'Phone number',
    narration: 'Plan',
  ),
  TxnCategory.electricity => (
    bank: 'Customer',
    account: 'Meter number',
    narration: 'Token',
  ),
  TxnCategory.cable => (
    bank: 'Customer',
    account: 'Smartcard',
    narration: 'Package',
  ),
  TxnCategory.mortgage => (
    bank: 'Product',
    account: 'Property',
    narration: 'Payment',
  ),
  _ => (bank: 'Bank', account: 'Account number', narration: 'Note'),
};
