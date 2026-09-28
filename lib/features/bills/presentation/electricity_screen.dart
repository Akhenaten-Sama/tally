import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/money/money.dart';
import '../../../core/theme/tally_colors.dart';
import '../../../core/widgets/bill_illustration.dart';
import '../data/bills_repository.dart';
import '../data/recent_billers.dart';
import '../domain/billers.dart';
import 'pay_bill.dart';
import 'widgets/bill_widgets.dart';

class ElectricityScreen extends ConsumerStatefulWidget {
  const ElectricityScreen({super.key, this.prefill});

  final BillPrefill? prefill;

  @override
  ConsumerState<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends ConsumerState<ElectricityScreen> {
  static final _presets = [
    2000,
    5000,
    10000,
    20000,
    50000,
    100000,
  ].map(Money.naira).toList();

  final _meterField = TextEditingController();
  final _amountField = TextEditingController();
  var _disco = Disco.ikeja;
  var _type = MeterType.prepaid;
  BillCustomer? _customer;
  var _verifying = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final p = widget.prefill;
    if (p != null) _apply(p);
  }

  @override
  void dispose() {
    _meterField.dispose();
    _amountField.dispose();
    super.dispose();
  }

  Money get _amount =>
      Money.naira(int.tryParse(_amountField.text.replaceAll(',', '')) ?? 0);

  double get _units => _amount.kobo / Disco.tariffPerKwh.kobo;

  void _apply(BillPrefill p) {
    _disco = p.disco ?? _disco;
    _type = p.meterType ?? _type;
    _meterField.text = p.meterNumber ?? '';
    _amountField.text = p.amount == null ? '' : '${p.amount!.kobo ~/ 100}';
    _customer = null;
    _error = null;
    // Saved meters are verified straight away.
    if (_meterField.text.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _verify());
    }
  }

  void _reset() => setState(() {
    _customer = null;
    _error = null;
  });

  Future<void> _verify() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _verifying = true;
      _error = null;
    });
    try {
      final customer = await ref
          .read(billsRepositoryProvider)
          .validateMeter(
            disco: _disco,
            type: _type,
            meterNumber: _meterField.text,
          );
      if (mounted) setState(() => _customer = customer);
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _pay() async {
    final customer = _customer!;
    final amount = _amount;
    final meter = _meterField.text;
    final disco = _disco;
    final type = _type;
    await payBill(
      context,
      ref,
      title: disco.name,
      amount: amount,
      rows: [
        ('Customer', customer.name),
        if (customer.address != null) ('Address', customer.address!),
        ('Meter', '$meter (${type.name})'),
        if (type == MeterType.prepaid)
          ('Estimated units', '${_units.toStringAsFixed(1)} kWh'),
      ],
      pay: (reference) => ref
          .read(billsRepositoryProvider)
          .payElectricity(
            reference: reference,
            disco: disco,
            type: type,
            meterNumber: meter,
            customer: customer,
            amount: amount,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customer = _customer;
    final canVerify =
        RegExp(r'^\d{11,13}$').hasMatch(_meterField.text) && !_verifying;
    final hasAmount = _amount >= Money.naira(1000);
    final saved = ref.watch(recentMetersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Electricity')),
      body: BillForm(
        button: customer == null
            ? FilledButton(
                onPressed: canVerify ? _verify : null,
                child: _verifying
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : const Text('Verify meter'),
              )
            : FilledButton(
                onPressed: hasAmount ? _pay : null,
                child: Text(
                  hasAmount
                      ? 'Pay ${_amount.format(showKobo: false)}'
                      : 'Enter an amount',
                ),
              ),
        children: [
          BillHeader(
            icon: Icons.bolt_rounded,
            leading: const BillIllustration(art: BillArt.electricity, size: 56),
            label: customer == null
                ? '${_disco.code} · ${_type.name}'
                : customer.name,
            value: customer == null
                ? 'Buy electricity'
                : _type == MeterType.prepaid && hasAmount
                ? '${_units.toStringAsFixed(1)} kWh'
                : _meterField.text,
            detail: customer?.address ?? 'Tokens arrive instantly',
          ),
          if (saved.isNotEmpty) ...[
            const SectionTitle('Saved meters'),
            SavedBillerStrip(
              items: saved,
              onSelected: (item) => setState(() => _apply(item.prefill)),
            ),
          ],
          const SectionTitle('Distribution company'),
          SizedBox(
            height: 76,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: Disco.values.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final d = Disco.values[i];
                return SizedBox(
                  width: 128,
                  child: OptionCard(
                    title: d.code,
                    subtitle: d.name,
                    selected: d == _disco,
                    onTap: () {
                      _disco = d;
                      _reset();
                    },
                  ),
                );
              },
            ),
          ),
          const SectionTitle('Meter'),
          SegmentedButton<MeterType>(
            segments: const [
              ButtonSegment(value: MeterType.prepaid, label: Text('Prepaid')),
              ButtonSegment(value: MeterType.postpaid, label: Text('Postpaid')),
            ],
            selected: {_type},
            onSelectionChanged: (s) {
              _type = s.single;
              _reset();
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _meterField,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(13),
            ],
            decoration: InputDecoration(
              hintText: 'Meter number (11–13 digits)',
              prefixIcon: const Icon(Icons.speed_rounded),
              errorText: _error,
            ),
            onChanged: (_) => _reset(),
          ),
          if (customer != null) ...[
            const SizedBox(height: 12),
            CustomerBanner(name: customer.name, address: customer.address),
            const SectionTitle('How much?'),
            OptionGrid(
              columns: 3,
              aspectRatio: 1.7,
              children: [
                for (final preset in _presets)
                  OptionCard(
                    title: preset.format(showKobo: false),
                    centered: true,
                    subtitle: _type == MeterType.prepaid
                        ? '≈ ${(preset.kobo / Disco.tariffPerKwh.kobo).toStringAsFixed(0)} kWh'
                        : null,
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
                LengthLimitingTextInputFormatter(7),
              ],
              decoration: const InputDecoration(
                prefixText: '₦ ',
                hintText: 'Another amount (minimum ₦1,000)',
              ),
              onChanged: (_) => setState(() {}),
            ),
          ] else if (!_verifying) ...[
            const SizedBox(height: 16),
            Text(
              "We'll check the meter with ${_disco.code} before you pay, so "
              'you can confirm the name and address.',
              style: TextStyle(color: context.tally.muted),
            ),
          ],
        ],
      ),
    );
  }
}
