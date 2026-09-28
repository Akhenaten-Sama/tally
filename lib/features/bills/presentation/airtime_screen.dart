import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/money/money.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tally_colors.dart';
import '../../auth/domain/phone_number.dart';
import '../data/bills_repository.dart';
import '../domain/billers.dart';
import 'pay_bill.dart';
import 'widgets/bill_widgets.dart';

enum TopUpKind { airtime, data }

class AirtimeScreen extends ConsumerStatefulWidget {
  const AirtimeScreen({super.key, this.initialKind = TopUpKind.airtime});

  final TopUpKind initialKind;

  @override
  ConsumerState<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends ConsumerState<AirtimeScreen> {
  static final _presets = [100, 200, 500, 1000, 2000, 5000].map(Money.naira);

  late var _kind = widget.initialKind;
  final _phoneField = TextEditingController();
  final _amountField = TextEditingController();
  MobileNetwork? _network;
  DataPlan? _plan;

  @override
  void dispose() {
    _phoneField.dispose();
    _amountField.dispose();
    super.dispose();
  }

  PhoneNumber? get _phone => PhoneNumber.tryParse(_phoneField.text);

  Money get _amount =>
      Money.naira(int.tryParse(_amountField.text.replaceAll(',', '')) ?? 0);

  bool get _canContinue {
    if (_phone == null || _network == null) return false;
    return switch (_kind) {
      TopUpKind.airtime =>
        _amount >= Money.naira(50) && _amount <= Money.naira(50000),
      TopUpKind.data => _plan != null && _plan!.network == _network,
    };
  }

  void _onPhoneChanged(String value) {
    final phone = PhoneNumber.tryParse(value);
    setState(() {
      if (phone != null) {
        _network = MobileNetwork.detect(phone) ?? _network;
        FocusScope.of(context).unfocus();
      }
    });
  }

  Future<void> _continue() async {
    final phone = _phone!;
    final network = _network!;
    final repository = ref.read(billsRepositoryProvider);

    switch (_kind) {
      case TopUpKind.airtime:
        final amount = _amount;
        await payBill(
          context,
          ref,
          title: '${network.label} airtime',
          amount: amount,
          rows: [('Phone number', phone.display), ('Network', network.label)],
          pay: (reference) => repository.buyAirtime(
            reference: reference,
            network: network,
            phone: phone,
            amount: amount,
          ),
        );
      case TopUpKind.data:
        final plan = _plan!;
        await payBill(
          context,
          ref,
          title: '${network.label} data',
          amount: plan.price,
          rows: [('Phone number', phone.display), ('Plan', plan.label)],
          pay: (reference) => repository.buyData(
            reference: reference,
            plan: plan,
            phone: phone,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final network = _network;
    return Scaffold(
      appBar: AppBar(title: const Text('Airtime & data')),
      body: BillForm(
        button: FilledButton(
          onPressed: _canContinue ? _continue : null,
          child: const Text('Continue'),
        ),
        children: [
          SegmentedButton<TopUpKind>(
            segments: const [
              ButtonSegment(value: TopUpKind.airtime, label: Text('Airtime')),
              ButtonSegment(value: TopUpKind.data, label: Text('Data')),
            ],
            selected: {_kind},
            onSelectionChanged: (s) => setState(() => _kind = s.single),
          ),
          const FieldLabel('Phone number'),
          TextField(
            controller: _phoneField,
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumber],
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d+ ]')),
              LengthLimitingTextInputFormatter(16),
            ],
            decoration: const InputDecoration(hintText: '0803 123 4567'),
            onChanged: _onPhoneChanged,
          ),
          const FieldLabel('Network'),
          Row(
            children: [
              for (final n in MobileNetwork.values)
                BillerChoice(
                  label: n.label,
                  color: n.color,
                  onColor: n.onColor,
                  selected: n == network,
                  onTap: () => setState(() {
                    _network = n;
                    _plan = null;
                  }),
                ),
            ],
          ),
          if (_kind == TopUpKind.airtime) ...[
            const FieldLabel('Amount'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final preset in _presets)
                  ChoiceChip(
                    label: Text(preset.format(showKobo: false)),
                    selected: _amount == preset,
                    onSelected: (_) => setState(
                      () => _amountField.text = '${preset.kobo ~/ 100}',
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountField,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(5),
              ],
              decoration: const InputDecoration(
                prefixText: '₦ ',
                hintText: 'Or enter an amount (₦50 – ₦50,000)',
              ),
              onChanged: (_) => setState(() {}),
            ),
          ] else ...[
            const FieldLabel('Choose a plan'),
            if (network == null)
              Text(
                'Enter a number or pick a network to see plans.',
                style: TextStyle(color: context.tally.muted),
              )
            else
              for (final plan in network.dataPlans)
                _PlanTile(
                  plan: plan,
                  selected: plan == _plan,
                  onTap: () => setState(() => _plan = plan),
                ),
          ],
        ],
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final DataPlan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tally = context.tally;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        button: true,
        selected: selected,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: tally.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? tally.debit : tally.border,
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Text(
                  plan.size,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${plan.validityDays} days',
                  style: TextStyle(color: tally.muted),
                ),
                const Spacer(),
                Text(
                  plan.price.format(showKobo: false),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFeatures: amountFeatures,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
