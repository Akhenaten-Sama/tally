import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/kora_colors.dart';
import '../../../core/utils/share_image.dart';
import '../../../core/widgets/error_view.dart';
import '../data/transaction_repository.dart';
import 'widgets/receipt_view.dart';

class TransactionDetailScreen extends ConsumerStatefulWidget {
  const TransactionDetailScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState
    extends ConsumerState<TransactionDetailScreen> {
  final _receiptKey = GlobalKey();
  var _sharing = false;

  Future<void> _share(String reference) async {
    final box = context.findRenderObject() as RenderBox?;
    setState(() => _sharing = true);
    try {
      await shareWidgetAsImage(
        _receiptKey,
        fileName: 'kora-receipt-$reference',
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final transaction = ref.watch(transactionProvider(widget.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction details')),
      body: switch (transaction) {
        AsyncData(:final value) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: RepaintBoundary(
            key: _receiptKey,
            // Opaque backdrop so the shared PNG has no transparent corners.
            child: ColoredBox(
              color: context.kora.background,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ReceiptView(transaction: value),
              ),
            ),
          ),
        ),
        AsyncError(:final error) => Center(child: ErrorView(error: error)),
        _ => const Center(child: CircularProgressIndicator()),
      },
      bottomNavigationBar: transaction.hasValue
          ? SafeArea(
              minimum: const EdgeInsets.all(20),
              child: FilledButton.icon(
                onPressed: _sharing
                    ? null
                    : () => _share(transaction.requireValue.reference),
                icon: const Icon(Icons.ios_share_rounded),
                label: const Text('Share receipt'),
              ),
            )
          : null,
    );
  }
}
