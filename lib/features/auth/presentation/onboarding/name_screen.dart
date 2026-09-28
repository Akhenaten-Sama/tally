import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import 'onboarding_controller.dart';
import 'onboarding_scaffold.dart';

class NameScreen extends ConsumerStatefulWidget {
  const NameScreen({super.key});

  @override
  ConsumerState<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends ConsumerState<NameScreen> {
  final _first = TextEditingController();
  final _last = TextEditingController();

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    super.dispose();
  }

  bool get _valid =>
      _first.text.trim().length >= 2 && _last.text.trim().length >= 2;

  void _continue() {
    ref.read(onboardingProvider.notifier).setName(_first.text, _last.text);
    context.push(Routes.onboardingPasscode);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 3,
      title: "What's your name?",
      subtitle: 'Use the name on your BVN so transfers to you go through.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _first,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.givenName],
            decoration: const InputDecoration(labelText: 'First name'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _last,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.familyName],
            decoration: const InputDecoration(labelText: 'Last name'),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _valid ? _continue() : null,
          ),
          const Spacer(),
          FilledButton(
            onPressed: _valid ? _continue : null,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
