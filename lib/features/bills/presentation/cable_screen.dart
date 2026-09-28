import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/tally_colors.dart';
import '../../../core/widgets/bill_illustration.dart';
import '../data/bills_repository.dart';
import '../data/recent_billers.dart';
import '../domain/billers.dart';
import 'pay_bill.dart';
import 'widgets/bill_widgets.dart';

class CableScreen extends ConsumerStatefulWidget {
  const CableScreen({super.key, this.prefill});

  final BillPrefill? prefill;

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
  void initState() {
    super.initState();
    final p = widget.prefill;
    if (p != null) _apply(p);
  }

  @override
  void dispose() {
    _cardField.dispose();
    super.dispose();
  }

  void _apply(BillPrefill p) {
    _provider = p.cableProvider ?? _provider;
    _cardField.text = p.smartcard ?? '';
    _customer = null;
    _package = null;
    _error = null;
    if (_cardField.text.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _verify());
    }
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
    final package = _package;
    final canVerify =
        RegExp(r'^\d{10,11}$').hasMatch(_cardField.text) && !_verifying;
    final saved = ref.watch(recentSmartcardsProvider);
    final packages = _provider.packages;

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
                onPressed: package == null ? null : _pay,
                child: Text(
                  package == null
                      ? 'Choose a package'
                      : 'Pay ${package.price.format(showKobo: false)}',
                ),
              ),
        children: [
          BillHeader(
            icon: Icons.tv_rounded,
            leading: const BillIllustration(art: BillArt.cable, size: 56),
            label: customer?.name ?? _provider.label,
            value: package == null
                ? (customer == null ? 'Renew your TV' : 'Pick a package')
                : '${package.name} · ${package.price.format(showKobo: false)}',
            detail: customer == null
                ? 'Subscriptions activate in minutes'
                : 'Smartcard ${_cardField.text}',
          ),
          if (saved.isNotEmpty) ...[
            const SectionTitle('Saved smartcards'),
            SavedBillerStrip(
              items: saved,
              onSelected: (item) => setState(() => _apply(item.prefill)),
            ),
          ],
          const SectionTitle('Provider'),
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
          const SectionTitle('Smartcard / IUC number'),
          TextField(
            controller: _cardField,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            decoration: InputDecoration(
              hintText: '10 or 11 digits',
              prefixIcon: const Icon(Icons.credit_card_rounded),
              errorText: _error,
            ),
            onChanged: (_) => _reset(),
          ),
          if (customer != null) ...[
            const SizedBox(height: 12),
            CustomerBanner(name: customer.name),
            const SectionTitle('Packages'),
            OptionGrid(
              columns: 2,
              aspectRatio: 2.1,
              children: [
                for (final (i, p) in packages.indexed)
                  OptionCard(
                    title: p.name,
                    subtitle: '${p.price.format(showKobo: false)} / month',
                    badge: i == packages.length ~/ 2 ? 'Popular' : null,
                    selected: p == package,
                    onTap: () => setState(() => _package = p),
                  ),
              ],
            ),
          ] else if (!_verifying) ...[
            const SizedBox(height: 16),
            Text(
              "You'll find the number on your decoder or on the side of "
              'your smartcard.',
              style: TextStyle(color: context.tally.muted),
            ),
          ],
        ],
      ),
    );
  }
}
