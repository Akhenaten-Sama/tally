import 'package:flutter/material.dart';

import '../../../../core/errors/app_exception.dart';
import '../widgets/code_entry.dart';
import 'onboarding_scaffold.dart';

/// Enter a new secret, then enter it again to confirm. Used for both the
/// login passcode and the transaction PIN.
class CreateCodeScreen extends StatefulWidget {
  const CreateCodeScreen({
    super.key,
    required this.step,
    required this.length,
    required this.title,
    required this.subtitle,
    required this.confirmTitle,
    required this.onCreated,
  });

  final int step;
  final int length;
  final String title;
  final String subtitle;
  final String confirmTitle;
  final Future<void> Function(String code) onCreated;

  @override
  State<CreateCodeScreen> createState() => _CreateCodeScreenState();
}

class _CreateCodeScreenState extends State<CreateCodeScreen> {
  String? _first;

  Future<void> _onCompleted(String code) async {
    final first = _first;
    if (first == null) {
      if (isTooSimpleCode(code)) {
        throw const ValidationException(
          'Too easy to guess. Avoid repeated or sequential digits.',
        );
      }
      setState(() => _first = code);
      return;
    }
    if (code != first) {
      setState(() => _first = null);
      throw const ValidationException("Those didn't match. Start again.");
    }
    await widget.onCreated(code);
  }

  @override
  Widget build(BuildContext context) {
    final confirming = _first != null;
    return OnboardingScaffold(
      step: widget.step,
      title: confirming ? widget.confirmTitle : widget.title,
      subtitle: widget.subtitle,
      child: Column(
        children: [
          const Spacer(),
          CodeEntry(length: widget.length, onCompleted: _onCompleted),
        ],
      ),
    );
  }
}

/// Rejects 1111, 1234, 4321 and the like.
bool isTooSimpleCode(String code) {
  if (code.split('').toSet().length == 1) return true;
  const ascending = '01234567890';
  const descending = '09876543210';
  return ascending.contains(code) || descending.contains(code);
}
