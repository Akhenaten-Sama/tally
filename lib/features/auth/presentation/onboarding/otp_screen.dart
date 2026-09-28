import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/errors/app_exception.dart';
import '../../data/auth_repository.dart';
import '../widgets/code_entry.dart';
import 'onboarding_controller.dart';
import 'onboarding_scaffold.dart';
import '../../../../core/brand/brand.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  static const _resendAfter = 60;

  var _secondsLeft = _resendAfter;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendAfter);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) timer.cancel();
      setState(() => _secondsLeft--);
    });
  }

  Future<void> _resend() async {
    try {
      await ref.read(onboardingProvider.notifier).resendOtp();
      _startCountdown();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('New code sent')));
    } on AppException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final phone = ref.watch(onboardingProvider).phone;

    return OnboardingScaffold(
      step: 2,
      title: 'Enter the 6-digit code',
      subtitle: 'Sent by SMS to ${phone?.display ?? 'your phone'}.',
      child: Column(
        children: [
          const Spacer(),
          CodeEntry(
            length: 6,
            obscure: false,
            hint: Brand.current.showDemoHints
                ? 'Demo code: ${MockAuthRepository.demoOtp}'
                : null,
            onCompleted: (code) async {
              await ref.read(onboardingProvider.notifier).verifyOtp(code);
              if (context.mounted) {
                unawaited(context.push(Routes.onboardingName));
              }
            },
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _secondsLeft > 0 ? null : _resend,
            child: Text(
              _secondsLeft > 0
                  ? 'Resend code in ${_secondsLeft}s'
                  : 'Resend code',
            ),
          ),
        ],
      ),
    );
  }
}
