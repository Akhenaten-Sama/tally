import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/brand/brand.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tally_colors.dart';
import '../../account/data/account_repository.dart';
import '../../profile/data/profile_repository.dart';
import '../../transactions/data/transaction_repository.dart';
import '../data/statement_pdf.dart';
import '../domain/statement.dart';

final _date = DateFormat('d MMM yyyy');
final _file = DateFormat('d-MMM-yyyy');

enum _Period {
  days30('Last 30 days'),
  months3('Last 3 months'),
  months6('Last 6 months'),
  year('This year'),
  custom('Custom');

  const _Period(this.label);

  final String label;
}

class StatementScreen extends ConsumerStatefulWidget {
  const StatementScreen({super.key});

  @override
  ConsumerState<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends ConsumerState<StatementScreen> {
  var _period = _Period.days30;
  late DateTimeRange _range = _rangeFor(_Period.days30);
  var _busy = false;

  static DateTimeRange _rangeFor(_Period period) {
    final today = DateUtils.dateOnly(DateTime.now());
    final start = switch (period) {
      _Period.days30 => today.subtract(const Duration(days: 29)),
      _Period.months3 => DateTime(today.year, today.month - 3, today.day + 1),
      _Period.months6 => DateTime(today.year, today.month - 6, today.day + 1),
      _Period.year || _Period.custom => DateTime(today.year),
    };
    return DateTimeRange(start: start, end: today);
  }

  Future<void> _pick(_Period period) async {
    if (period != _Period.custom) {
      setState(() {
        _period = period;
        _range = _rangeFor(period);
      });
      return;
    }
    final today = DateUtils.dateOnly(DateTime.now());
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(today.year - 3),
      lastDate: today,
      initialDateRange: _range,
    );
    if (picked != null) {
      setState(() {
        _period = period;
        _range = picked;
      });
    }
  }

  Future<void> _download(Statement statement) async {
    final account = ref.read(primaryAccountProvider).value;
    if (account == null) return;
    final box = context.findRenderObject() as RenderBox?;
    setState(() => _busy = true);
    try {
      final bytes = await buildStatementPdf(
        statement: statement,
        account: account,
        profile: ref.read(customerProfileProvider).value,
      );
      final dir = await getTemporaryDirectory();
      final name =
          '${Brand.current.shortName}-statement-'
          '${_file.format(statement.from)}-to-${_file.format(statement.to)}.pdf';
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(bytes, flush: true);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/pdf')],
          sharePositionOrigin: box == null
              ? null
              : box.localToGlobal(Offset.zero) & box.size,
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(allTransactionsProvider).value;
    final balance = ref.watch(primaryAccountProvider).value?.balance;
    final statement = transactions == null || balance == null
        ? null
        : Statement.build(
            transactions: transactions,
            currentBalance: balance,
            from: _range.start,
            to: _range.end,
          );
    final tally = context.tally;

    return Scaffold(
      appBar: AppBar(title: const Text('Account statement')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        children: [
          Text(
            'Choose a period, then download a PDF you can save, print or '
            'send to your employer or embassy.',
            style: TextStyle(color: tally.muted),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in _Period.values)
                ChoiceChip(
                  label: Text(p.label),
                  selected: p == _period,
                  onSelected: (_) => _pick(p),
                ),
            ],
          ),
          const SizedBox(height: 20),
          if (statement != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: tally.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: tally.border),
              ),
              child: Column(
                children: [
                  _Row(
                    'Period',
                    '${_date.format(statement.from)} – '
                        '${_date.format(statement.to)}',
                  ),
                  _Row('Transactions', '${statement.lines.length}'),
                  _Row('Opening balance', statement.opening.format()),
                  _Row('Money in', statement.moneyIn.format()),
                  _Row('Money out', statement.moneyOut.format()),
                  const Divider(height: 20),
                  _Row(
                    'Closing balance',
                    statement.closing.format(),
                    bold: true,
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: FilledButton.icon(
          onPressed: statement == null || _busy
              ? null
              : () => _download(statement),
          icon: _busy
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : const Icon(Icons.picture_as_pdf_outlined),
          label: const Text('Download PDF'),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Text(label, style: TextStyle(color: context.tally.muted)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            fontFeatures: amountFeatures,
          ),
        ),
      ],
    ),
  );
}
