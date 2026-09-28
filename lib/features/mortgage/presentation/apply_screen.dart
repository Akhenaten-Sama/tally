import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/money/money.dart';
import '../../../core/theme/tally_colors.dart';
import '../../account/data/account_repository.dart';
import '../data/mortgage_repository.dart';
import '../domain/amortization.dart';
import 'calculator_screen.dart';

class ApplyScreen extends ConsumerStatefulWidget {
  const ApplyScreen({super.key, required this.quote});

  final MortgageQuote quote;

  @override
  ConsumerState<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends ConsumerState<ApplyScreen> {
  final _property = TextEditingController();
  final _income = TextEditingController();
  final _employer = TextEditingController();
  var _consent = false;
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _property.dispose();
    _income.dispose();
    _employer.dispose();
    super.dispose();
  }

  Money get _monthly => monthlyRepayment(
    principal: widget.quote.amount,
    annualRateBps: widget.quote.product.rateBps,
    months: widget.quote.months,
  );

  Money get _incomeValue =>
      Money.naira(int.tryParse(_income.text.replaceAll(',', '')) ?? 0);

  bool get _affordable => _incomeValue.kobo >= _monthly.kobo * 3;

  bool get _complete =>
      _property.text.trim().length >= 5 &&
      !_incomeValue.isZero &&
      _employer.text.trim().length >= 2 &&
      _consent;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final application = await ref
          .read(mortgageRepositoryProvider)
          .submitApplication(
            product: widget.quote.product,
            amount: widget.quote.amount,
            tenorMonths: widget.quote.months,
            property: _property.text.trim(),
            monthlyIncome: _incomeValue,
          );
      if (mounted) context.go(Routes.mortgageApplication(application.id));
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final quote = widget.quote;
    final tally = context.tally;
    final name = ref.watch(primaryAccountProvider).value?.holderName;
    final showAffordability = !_incomeValue.isZero && !_affordable;

    return Scaffold(
      appBar: AppBar(title: const Text('Apply')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: tally.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: tally.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quote.product.name,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${quote.amount.format(showKobo: false)} over '
                          '${quote.months ~/ 12} years · '
                          '${_monthly.format()} a month',
                          style: TextStyle(color: tally.muted),
                        ),
                        if (name != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Applicant: $name',
                            style: TextStyle(color: tally.muted),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _property,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Property',
                      hintText: 'e.g. 3-bedroom flat, Gbagada, Lagos',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _income,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Monthly take-home pay',
                      prefixText: '₦ ',
                      errorText: showAffordability
                          ? 'Repayments would be more than a third of your pay. '
                                'Try a smaller amount or longer tenor.'
                          : null,
                      errorMaxLines: 3,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _employer,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Employer or business name',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _consent,
                    onChanged: (v) => setState(() => _consent = v ?? false),
                    title: const Text(
                      'I agree to a credit check and confirm these details '
                      'are correct.',
                    ),
                  ),
                  if (_error != null)
                    Text(
                      _error!,
                      style: const TextStyle(color: AppColors.error),
                    ),
                ],
              ),
            ),
            SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: FilledButton(
                onPressed: _complete && _affordable && !_busy ? _submit : null,
                child: _busy
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : const Text('Submit application'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
