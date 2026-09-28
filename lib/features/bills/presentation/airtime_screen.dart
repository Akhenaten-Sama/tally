import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/money/money.dart';
import '../../../core/theme/tally_colors.dart';
import '../../../core/widgets/bill_illustration.dart';
import '../../auth/domain/phone_number.dart';
import '../../profile/data/profile_repository.dart';
import '../data/bills_repository.dart';
import '../data/recent_billers.dart';
import '../domain/billers.dart';
import 'pay_bill.dart';
import 'widgets/bill_widgets.dart';

enum TopUpKind { airtime, data }

class AirtimeScreen extends ConsumerStatefulWidget {
  const AirtimeScreen({super.key, this.prefill});

  final BillPrefill? prefill;

  @override
  ConsumerState<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends ConsumerState<AirtimeScreen> {
  static final _presets = [
    100,
    200,
    500,
    1000,
    2000,
    5000,
  ].map(Money.naira).toList();

  late var _kind = (widget.prefill?.data ?? false)
      ? TopUpKind.data
      : TopUpKind.airtime;
  final _phoneField = TextEditingController();
  final _amountField = TextEditingController();
  MobileNetwork? _network;
  DataPlan? _plan;

  @override
  void initState() {
    super.initState();
    final p = widget.prefill;
    if (p?.phone != null) _usePhone(p!.phone!, network: p.network);
    if (p?.amount != null) _amountField.text = '${p!.amount!.kobo ~/ 100}';
  }

  @override
  void dispose() {
    _phoneField.dispose();
    _amountField.dispose();
    super.dispose();
  }

  PhoneNumber? get _phone => PhoneNumber.tryParse(_phoneField.text);

  Money get _amount =>
      Money.naira(int.tryParse(_amountField.text.replaceAll(',', '')) ?? 0);

  bool get _amountValid =>
      _amount >= Money.naira(50) && _amount <= Money.naira(50000);

  bool get _canContinue {
    if (_phone == null || _network == null) return false;
    return switch (_kind) {
      TopUpKind.airtime => _amountValid,
      TopUpKind.data => _plan != null && _plan!.network == _network,
    };
  }

  void _usePhone(PhoneNumber phone, {MobileNetwork? network}) {
    _phoneField.text = phone.display;
    _network = network ?? MobileNetwork.detect(phone) ?? _network;
    if (_plan?.network != _network) _plan = null;
  }

  void _onPhoneChanged(String value) {
    final phone = PhoneNumber.tryParse(value);
    setState(() {
      if (phone != null) {
        _network = MobileNetwork.detect(phone) ?? _network;
        if (_plan?.network != _network) _plan = null;
        FocusScope.of(context).unfocus();
      }
    });
  }

  String get _buttonLabel {
    final network = _network?.label ?? '';
    return switch (_kind) {
      TopUpKind.airtime when _amountValid =>
        'Buy ${_amount.format(showKobo: false)} $network airtime',
      TopUpKind.data when _plan != null =>
        'Buy ${_plan!.size} for ${_plan!.price.format(showKobo: false)}',
      _ => 'Continue',
    };
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
    final phone = _phone;
    final myPhone = PhoneNumber.tryParse(
      ref.watch(customerProfileProvider).value?.phone ?? '',
    );
    final recents = ref
        .watch(recentPhonesProvider)
        .where((r) => r.prefill.phone != myPhone)
        .toList();

    final headerValue = switch (_kind) {
      TopUpKind.airtime => _amountValid ? _amount.format() : '₦0',
      TopUpKind.data => _plan?.size ?? 'Pick a plan',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Airtime & data')),
      body: BillForm(
        button: FilledButton(
          onPressed: _canContinue ? _continue : null,
          child: Text(_buttonLabel),
        ),
        children: [
          BillHeader(
            icon: Icons.phone_android_rounded,
            leading: network == null
                ? BillIllustration(
                    art: _kind == TopUpKind.airtime
                        ? BillArt.airtime
                        : BillArt.data,
                    size: 56,
                  )
                : BillerBadge(
                    label: network.label,
                    color: network.color,
                    onColor: network.onColor,
                    size: 52,
                  ),
            label: _kind == TopUpKind.airtime ? 'Airtime' : 'Data bundle',
            value: headerValue,
            detail: phone == null
                ? 'Enter or pick a number below'
                : 'To ${phone.display}${network == null ? '' : ' · ${network.label}'}',
          ),
          const SizedBox(height: 16),
          SegmentedButton<TopUpKind>(
            segments: const [
              ButtonSegment(value: TopUpKind.airtime, label: Text('Airtime')),
              ButtonSegment(value: TopUpKind.data, label: Text('Data')),
            ],
            selected: {_kind},
            onSelectionChanged: (s) => setState(() => _kind = s.single),
          ),
          const SectionTitle('Who is it for?'),
          SavedBillerStrip(
            leading: [
              if (myPhone != null)
                SavedBiller(
                  title: 'My number',
                  subtitle: myPhone.display,
                  prefill: BillPrefill(phone: myPhone),
                  network: MobileNetwork.detect(myPhone),
                ),
            ],
            items: recents,
            onSelected: (item) => setState(
              () =>
                  _usePhone(item.prefill.phone!, network: item.prefill.network),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneField,
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumber],
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d+ ]')),
              LengthLimitingTextInputFormatter(16),
            ],
            decoration: const InputDecoration(
              hintText: '0803 123 4567',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
            onChanged: _onPhoneChanged,
          ),
          const SectionTitle('Network'),
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
            const SectionTitle('How much?'),
            OptionGrid(
              columns: 3,
              aspectRatio: 1.7,
              children: [
                for (final preset in _presets)
                  OptionCard(
                    title: preset.format(showKobo: false),
                    centered: true,
                    selected: _amount == preset,
                    onTap: () => setState(
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
                hintText: 'Another amount (₦50 – ₦50,000)',
              ),
              onChanged: (_) => setState(() {}),
            ),
          ] else ...[
            const SectionTitle('Choose a plan'),
            if (network == null)
              Text(
                'Enter a number or pick a network to see plans.',
                style: TextStyle(color: context.tally.muted),
              )
            else
              OptionGrid(
                columns: 2,
                aspectRatio: 2.1,
                children: [
                  for (final (i, plan) in network.dataPlans.indexed)
                    OptionCard(
                      title: plan.size,
                      subtitle:
                          '${plan.validityDays} days · '
                          '${plan.price.format(showKobo: false)}',
                      badge: i == 2 ? 'Popular' : null,
                      selected: plan == _plan,
                      onTap: () => setState(() => _plan = plan),
                    ),
                ],
              ),
          ],
        ],
      ),
    );
  }
}
