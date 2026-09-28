import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tally_colors.dart';
import '../../../core/widgets/error_view.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/bank_transaction.dart';

/// Step 3: the outcome. Watches the transaction live, so a pending transfer
/// flips to successful (or refunded) on this screen when it settles.
class TransferStatusScreen extends ConsumerWidget {
  const TransferStatusScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(transactionProvider(id), (previous, next) {
      final was = previous?.value?.status;
      final now = next.value?.status;
      if (was == TxnStatus.pending && now == TxnStatus.successful) {
        HapticFeedback.heavyImpact();
      }
    });
    final transaction = ref.watch(transactionProvider(id));

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: switch (transaction) {
            AsyncData(:final value) => _Outcome(transaction: value),
            AsyncError(:final error) => Center(child: ErrorView(error: error)),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ),
      ),
    );
  }
}

class _Outcome extends StatelessWidget {
  const _Outcome({required this.transaction});

  final BankTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final tally = context.tally;
    final isTransfer = t.category == TxnCategory.transfer;
    final (successTitle, successBody) = _successCopy(t);
    final (icon, color, title, body) = switch (t.status) {
      TxnStatus.successful => (
        Icons.check_rounded,
        tally.credit,
        successTitle,
        successBody,
      ),
      TxnStatus.pending => (
        Icons.hourglass_top_rounded,
        tally.pending,
        isTransfer ? 'Transfer processing' : 'Payment processing',
        "${isTransfer ? 'The receiving bank' : 'The provider'} hasn't "
            'confirmed yet. This usually takes under a minute, and this '
            'screen updates by itself.',
      ),
      TxnStatus.failed || TxnStatus.reversed => (
        Icons.close_rounded,
        AppColors.error,
        isTransfer ? 'Transfer failed' : 'Payment failed',
        '${isTransfer ? "${t.counterpartyName}'s bank couldn't accept this transfer" : "${t.counterpartyName} couldn't complete this payment"}. '
            '${t.total.format()} has been refunded to your balance.',
      ),
    };
    final token = t.status == TxnStatus.successful ? t.electricityToken : null;

    return Column(
      children: [
        const Spacer(),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
          child: Container(
            key: ValueKey(t.status),
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: color),
          ),
        ),
        const SizedBox(height: 24),
        Semantics(
          liveRegion: true,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          body,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyLarge?.copyWith(color: tally.muted),
        ),
        if (token != null) ...[
          const SizedBox(height: 20),
          _TokenCard(token: token),
        ],
        if (t.status == TxnStatus.pending) ...[
          const SizedBox(height: 24),
          const SizedBox(width: 120, child: LinearProgressIndicator()),
        ],
        const Spacer(),
        OutlinedButton(
          onPressed: () => context.push(Routes.transaction(t.id)),
          child: const Text('View receipt'),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () => context.go(Routes.home),
          child: const Text('Done'),
        ),
      ],
    );
  }
}

(String, String) _successCopy(BankTransaction t) {
  final amount = t.amount.format();
  final to = t.counterpartyAccount ?? '';
  return switch (t.category) {
    TxnCategory.mortgage => (
      'Repayment successful',
      '$amount paid towards your home. ${t.narration}.',
    ),
    TxnCategory.airtime => (
      'Airtime sent',
      '$amount ${t.counterpartyName.replaceAll('Airtime', 'airtime')} '
          'sent to $to.',
    ),
    TxnCategory.data => (
      'Data activated',
      '${t.narration} ${t.counterpartyName.replaceAll('Data', 'data')} '
          'is now on $to.',
    ),
    TxnCategory.electricity when t.electricityToken != null => (
      'Payment successful',
      'Enter this token on meter $to:',
    ),
    TxnCategory.electricity => (
      'Payment successful',
      '$amount paid to ${t.counterpartyName} for meter $to.',
    ),
    TxnCategory.cable => (
      'Subscription renewed',
      '${t.counterpartyName} is active on smartcard $to for 1 month.',
    ),
    _ => (
      'Transfer successful',
      '$amount is on its way to ${t.counterpartyName}.',
    ),
  };
}

class _TokenCard extends StatelessWidget {
  const _TokenCard({required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    final tally = context.tally;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      decoration: BoxDecoration(
        color: tally.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tally.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: SelectableText(
              token.replaceAll('-', ' '),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                fontFeatures: amountFeatures,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Copy token',
            icon: const Icon(Icons.copy_rounded),
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: token.replaceAll('-', '')),
              );
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Token copied')));
            },
          ),
        ],
      ),
    );
  }
}
