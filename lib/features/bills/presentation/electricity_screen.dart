import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/money/money.dart';
import '../../../core/theme/tally_colors.dart';
import '../data/bills_repository.dart';
import '../domain/billers.dart';
import 'pay_bill.dart';
import 'widgets/bill_widgets.dart';

class ElectricityScreen extends ConsumerStatefulWidget {
  const ElectricityScreen({super.key});

  @override
  ConsumerState<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends ConsumerState<ElectricityScreen> {
  final _meterField = TextEditingController();
  final _amountField = TextEditingController();
  var _disco = Disco.ikeja;
  var _type = MeterType.prepaid;
  BillCustomer? _customer;
  var _verifying = false;
  String? _error;

  @override
  void dispose() {
    _meterField.dispose();
    _amountField.dispose();
    super.dispose();
  }

  Money get _amount =>
      Money.naira(int.tryParse(_amountField.text.replaceAll(',', '')) ?? 0);

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
          (
            'Estimated units',
            '${(amount.kobo / Disco.tariffPerKwh.kobo).toStringAsFixed(1)} kWh',
          ),
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
                onPressed: _amount >= Money.naira(1000) ? _pay : null,
                child: const Text('Continue'),
              ),
        children: [
          const FieldLabel('Distribution company'),
          DropdownButtonFormField<Disco>(
            initialValue: _disco,
            isExpanded: true,
            items: [
              for (final d in Disco.values)
                DropdownMenuItem(
                  value: d,
                  child: Text('${d.name} (${d.code})'),
                ),
            ],
            onChanged: (d) {
              if (d == null) return;
              _disco = d;
              _reset();
            },
          ),
          const FieldLabel('Meter type'),
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
          const FieldLabel('Meter number'),
          TextField(
            controller: _meterField,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(13),
            ],
            decoration: InputDecoration(
              hintText: '11–13 digits',
              errorText: _error,
            ),
            onChanged: (_) => _reset(),
          ),
          if (customer != null) ...[
            const SizedBox(height: 12),
            CustomerBanner(name: customer.name, address: customer.address),
            const FieldLabel('Amount'),
            TextField(
              controller: _amountField,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(7),
              ],
              decoration: InputDecoration(
                prefixText: '₦ ',
                hintText: 'Minimum ₦1,000',
                helperText: _type == MeterType.prepaid && !_amount.isZero
                    ? '≈ ${(_amount.kobo / Disco.tariffPerKwh.kobo).toStringAsFixed(1)} kWh '
                          'at ${Disco.tariffPerKwh.format()}/kWh'
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
          if (customer == null && !_verifying) ...[
            const SizedBox(height: 16),
            Text(
              "We'll check the meter with ${_disco.code} before you pay.",
              style: TextStyle(color: context.tally.muted),
            ),
          ],
        ],
      ),
    );
  }
}
