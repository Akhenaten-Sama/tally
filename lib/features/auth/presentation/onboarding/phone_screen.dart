import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/errors/app_exception.dart';
import '../../domain/phone_number.dart';
import 'onboarding_controller.dart';
import 'onboarding_scaffold.dart';

class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  final _phone = TextEditingController();
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(onboardingProvider.notifier).requestOtp(_phone.text);
      if (mounted) unawaited(context.push(Routes.onboardingOtp));
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final valid = PhoneNumber.tryParse(_phone.text) != null;

    return OnboardingScaffold(
      step: 1,
      title: "What's your phone number?",
      subtitle: "We'll text you a code to confirm it's yours.",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _phone,
            autofocus: true,
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumber],
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d+ ]')),
              LengthLimitingTextInputFormatter(16),
            ],
            decoration: InputDecoration(
              labelText: 'Phone number',
              hintText: '0803 123 4567',
              prefixText: '🇳🇬  ',
              errorText: _error,
            ),
            onChanged: (value) {
              setState(() => _error = null);
              if (PhoneNumber.tryParse(value) != null) {
                FocusScope.of(context).unfocus();
              }
            },
          ),
          const Spacer(),
          FilledButton(
            onPressed: valid && !_busy ? _continue : null,
            child: _busy
                ? const SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : const Text('Send code'),
          ),
        ],
      ),
    );
  }
}
