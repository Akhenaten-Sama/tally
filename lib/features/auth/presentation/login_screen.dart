import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tally_colors.dart';
import '../data/auth_controller.dart';
import '../domain/phone_number.dart';
import 'widgets/code_entry.dart';
import '../../../core/brand/brand.dart';

/// Returning customer on a new device: phone number, then passcode.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneField = TextEditingController();
  PhoneNumber? _phone;

  @override
  void dispose() {
    _phoneField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phone = _phone;
    final typed = PhoneNumber.tryParse(_phoneField.text);

    return PopScope(
      // Back from the passcode step returns to the phone step.
      canPop: phone == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _phone = null);
      },
      child: Scaffold(
        appBar: AppBar(),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    phone == null ? 'Welcome back' : 'Enter your passcode',
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    phone == null
                        ? 'Log in with the phone number on your account.'
                        : 'For ${phone.display}',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.tally.muted,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (phone == null) ...[
                    TextField(
                      controller: _phoneField,
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[\d+ ]')),
                        LengthLimitingTextInputFormatter(16),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                        hintText: '0803 123 4567',
                        prefixText: '🇳🇬  ',
                      ),
                      onChanged: (value) {
                        setState(() {});
                        if (PhoneNumber.tryParse(value) != null) {
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: typed == null
                          ? null
                          : () => setState(() => _phone = typed),
                      child: const Text('Continue'),
                    ),
                  ] else ...[
                    const Spacer(),
                    CodeEntry(
                      length: 6,
                      hint: Brand.current.showDemoHints
                          ? 'Demo passcode: ${DemoCredentials.passcode}'
                          : null,
                      // The router moves to Home once signed in.
                      onCompleted: ref
                          .read(authControllerProvider.notifier)
                          .logIn,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
