import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/money/money.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kora_colors.dart';
import '../domain/amortization.dart';
import '../domain/mortgage.dart';

/// What the calculator hands to the application form.
typedef MortgageQuote = ({MortgageProduct product, Money amount, int months});

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key, required this.product});

  final MortgageProduct product;

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  static const _step = Money(50000000); // ₦500,000
  static const _minAmount = Money(100000000); // ₦1,000,000

  late var _amount = const Money(1500000000);
  late var _years = min(20, widget.product.maxYears);

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final kora = context.kora;
    final months = _years * 12;
    final monthly = monthlyRepayment(
      principal: _amount,
      annualRateBps: product.rateBps,
      months: months,
    );
    final totalPayable = Money(monthly.kobo * months);
    final totalInterest = totalPayable - _amount;
    // Lenders cap repayments at a third of take-home pay.
    final minIncome = Money(monthly.kobo * 3);
    final steps = (product.maxAmount - _minAmount).kobo ~/ _step.kobo;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kora.card,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly repayment',
                    style: TextStyle(
                      color: kora.onCard.withValues(alpha: 0.75),
                    ),
                  ),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      monthly.format(),
                      style: context.textTheme.headlineMedium?.copyWith(
                        color: kora.onCard,
                        fontWeight: FontWeight.w800,
                        fontFeatures: amountFeatures,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _CardRow('Interest rate', product.rateLabel),
                  _CardRow('Total interest', totalInterest.format()),
                  _CardRow('Total repayable', totalPayable.format()),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _SliderHeader('Loan amount', _amount.format(showKobo: false)),
            Slider(
              value: _amount.kobo.toDouble(),
              min: _minAmount.kobo.toDouble(),
              max: product.maxAmount.kobo.toDouble(),
              divisions: steps,
              label: _amount.format(showKobo: false),
              onChanged: (v) => setState(() => _amount = Money(v.round())),
            ),
            const SizedBox(height: 12),
            _SliderHeader(
              'Repay over',
              '$_years ${_years == 1 ? 'year' : 'years'}',
            ),
            Slider(
              value: _years.toDouble(),
              min: 1,
              max: product.maxYears.toDouble(),
              divisions: product.maxYears - 1,
              label: '$_years years',
              onChanged: (v) => setState(() => _years = v.round()),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kora.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: kora.secondary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'You need a take-home pay of at least '
                      '${minIncome.format(showKobo: false)} a month for this '
                      'loan.',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.push(
                Routes.mortgageApply,
                extra: (product: product, amount: _amount, months: months),
              ),
              child: const Text('Apply for this mortgage'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliderHeader extends StatelessWidget {
  const _SliderHeader(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(label, style: TextStyle(color: context.kora.muted)),
      const Spacer(),
      Text(
        value,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
          fontFeatures: amountFeatures,
        ),
      ),
    ],
  );
}

class _CardRow extends StatelessWidget {
  const _CardRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final onCard = context.kora.onCard;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: onCard.withValues(alpha: 0.75))),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: onCard,
              fontWeight: FontWeight.w700,
              fontFeatures: amountFeatures,
            ),
          ),
        ],
      ),
    );
  }
}
