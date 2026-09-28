import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/kora_colors.dart';
import '../../auth/data/auth_controller.dart';
import '../../auth/presentation/onboarding/create_code_screen.dart';
import '../../auth/presentation/widgets/code_entry.dart';

enum SecretKind {
  pin('transaction PIN', 4),
  passcode('passcode', 6);

  const SecretKind(this.label, this.length);

  final String label;
  final int length;
}

enum _Step { current, next, confirm }

/// Current code → new code → confirm. The current code goes through the
/// same attempt limit and lockout as everywhere else.
class ChangeCodeScreen extends ConsumerStatefulWidget {
  const ChangeCodeScreen({super.key, required this.kind});

  final SecretKind kind;

  @override
  ConsumerState<ChangeCodeScreen> createState() => _ChangeCodeScreenState();
}

class _ChangeCodeScreenState extends ConsumerState<ChangeCodeScreen> {
  var _step = _Step.current;
  String? _current;
  String? _next;

  Future<void> _onCompleted(String code) async {
    switch (_step) {
      case _Step.current:
        setState(() {
          _current = code;
          _step = _Step.next;
        });
      case _Step.next:
        if (isTooSimpleCode(code)) {
          throw const ValidationException(
            'Too easy to guess. Avoid repeated or sequential digits.',
          );
        }
        if (code == _current) {
          throw const ValidationException('Choose a different code.');
        }
        setState(() {
          _next = code;
          _step = _Step.confirm;
        });
      case _Step.confirm:
        if (code != _next) {
          setState(() => _step = _Step.next);
          throw const ValidationException("Those didn't match. Try again.");
        }
        await _save(code);
    }
  }

  Future<void> _save(String next) async {
    final auth = ref.read(authControllerProvider.notifier);
    try {
      if (widget.kind == SecretKind.pin) {
        await auth.changePin(current: _current!, next: next);
      } else {
        await auth.changePasscode(current: _current!, next: next);
      }
    } on AppException {
      // Wrong current code: start over from the first step.
      setState(() => _step = _Step.current);
      rethrow;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Your ${widget.kind.label} has been changed')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.kind.label;
    final (title, subtitle) = switch (_step) {
      _Step.current => ('Enter your current $label', ''),
      _Step.next => ('Choose a new $label', 'Avoid birthdays and repeats.'),
      _Step.confirm => ('Confirm your new $label', ''),
    };

    return Scaffold(
      appBar: AppBar(title: Text('Change $label')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(subtitle, style: TextStyle(color: context.kora.muted)),
              ],
              const Spacer(),
              CodeEntry(length: widget.kind.length, onCompleted: _onCompleted),
            ],
          ),
        ),
      ),
    );
  }
}
