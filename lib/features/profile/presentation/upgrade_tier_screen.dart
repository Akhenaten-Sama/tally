import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/tally_colors.dart';
import '../../account/domain/account.dart';
import '../../bills/presentation/widgets/bill_widgets.dart';
import '../data/profile_repository.dart';

class UpgradeTierScreen extends ConsumerStatefulWidget {
  const UpgradeTierScreen({super.key});

  @override
  ConsumerState<UpgradeTierScreen> createState() => _UpgradeTierScreenState();
}

class _UpgradeTierScreenState extends ConsumerState<UpgradeTierScreen> {
  final _nin = TextEditingController();
  final _address = TextEditingController();
  var _consent = false;
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _nin.dispose();
    _address.dispose();
    super.dispose();
  }

  bool get _complete =>
      _nin.text.length == 11 && _address.text.trim().length >= 10 && _consent;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(profileRepositoryProvider)
          .upgradeToTier3(nin: _nin.text, address: _address.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You're now on ${KycTier.tier3.label}. You can send up to "
            '${KycTier.tier3.dailyLimit.format(showKobo: false)} a day.',
          ),
        ),
      );
      context.pop();
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upgrade to ${KycTier.tier3.label}')),
      body: BillForm(
        button: FilledButton(
          onPressed: _complete && !_busy ? _submit : null,
          child: _busy
              ? const SizedBox.square(
                  dimension: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : const Text('Verify and upgrade'),
        ),
        children: [
          Text(
            'Raise your daily limit to '
            '${KycTier.tier3.dailyLimit.format(showKobo: false)} by adding '
            'your National Identification Number and home address.',
            style: TextStyle(color: context.tally.muted),
          ),
          const FieldLabel('NIN'),
          TextField(
            controller: _nin,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            decoration: const InputDecoration(
              hintText: '11 digits',
              helperText: 'Dial *346# on your registered line to get it',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const FieldLabel('Home address'),
          TextField(
            controller: _address,
            textCapitalization: TextCapitalization.words,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'House number, street, area, state',
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
              'I consent to my NIN being verified with NIMC and confirm '
              'this address is correct.',
            ),
          ),
          if (_error != null)
            Text(_error!, style: const TextStyle(color: AppColors.error)),
        ],
      ),
    );
  }
}
