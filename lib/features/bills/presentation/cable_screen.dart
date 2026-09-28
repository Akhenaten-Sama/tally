import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tally_colors.dart';
import '../data/bills_repository.dart';
import '../domain/billers.dart';
import 'pay_bill.dart';
import 'widgets/bill_widgets.dart';

class CableScreen extends ConsumerStatefulWidget {
  const CableScreen({super.key});

  @override
  ConsumerState<CableScreen> createState() => _CableScreenState();
}

class _CableScreenState extends ConsumerState<CableScreen> {
  final _cardField = TextEditingController();
  var _provider = CableProvider.dstv;
  CablePackage? _package;
  BillCustomer? _customer;
  var _verifying = false;
  String? _error;

  @override
  void dispose() {
    _cardField.dispose();
    super.dispose();
  }

  void _reset() => setState(() {
    _customer = null;
    _package = null;
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
          .validateSmartcard(
            provider: _provider,
            smartcardNumber: _cardField.text,
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
    final package = _package!;
    final card = _cardField.text;
    await payBill(
      context,
      ref,
      title: '${package.provider.label} subscription',
      amount: package.price,
      rows: [
        ('Customer', customer.name),
        ('Smartcard', card),
        ('Package', '${package.name} · 1 month'),
      ],
      pay: (reference) => ref
          .read(billsRepositoryProvider)
          .payCable(
            reference: reference,
            package: package,
            smartcardNumber: card,
            customer: customer,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customer = _customer;
    final canVerify =
        RegExp(r'^\d{10,11}$').hasMatch(_cardField.text) && !_verifying;

    return Scaffold(
      appBar: AppBar(title: const Text('Cable TV')),
      body: BillForm(
        button: customer == null
            ? FilledButton(
                onPressed: canVerify ? _verify : null,
                child: _verifying
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : const Text('Verify smartcard'),
              )
            : FilledButton(
                onPressed: _package == null ? null : _pay,
                child: const Text('Continue'),
              ),
        children: [
          const FieldLabel('Provider'),
          Row(
            children: [
              for (final p in CableProvider.values)
                BillerChoice(
                  label: p.label,
                  color: p.color,
                  selected: p == _provider,
                  onTap: () {
                    _provider = p;
                    _reset();
                  },
                ),
            ],
          ),
          const FieldLabel('Smartcard / IUC number'),
          TextField(
            controller: _cardField,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            decoration: InputDecoration(
              hintText: '10 or 11 digits',
              errorText: _error,
            ),
            onChanged: (_) => _reset(),
          ),
          if (customer != null) ...[
            const SizedBox(height: 12),
            CustomerBanner(name: customer.name),
            const FieldLabel('Package'),
            for (final package in _provider.packages)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _PackageTile(
                  package: package,
                  selected: package == _package,
                  onTap: () => setState(() => _package = package),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _PackageTile extends StatelessWidget {
  const _PackageTile({
    required this.package,
    required this.selected,
    required this.onTap,
  });

  final CablePackage package;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tally = context.tally;
    return Semantics(
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
                package.name,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '${package.price.format(showKobo: false)}/month',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFeatures: amountFeatures,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
