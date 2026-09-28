import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/kora_colors.dart';
import '../../../../core/widgets/number_pad.dart';

/// Digit indicators, a status line and a keypad. Calls [onCompleted] when
/// [length] digits are in; if it throws an [AppException] the message is
/// shown, the field shakes and clears. Used for PINs, passcodes and OTPs.
class CodeEntry extends StatefulWidget {
  const CodeEntry({
    super.key,
    required this.length,
    required this.onCompleted,
    this.obscure = true,
    this.hint,
    this.leading,
  });

  final int length;
  final Future<void> Function(String code) onCompleted;

  /// Dots for secrets; visible digits for one-time codes.
  final bool obscure;
  final String? hint;

  /// Bottom-left keypad slot, e.g. a biometrics button.
  final Widget? leading;

  @override
  State<CodeEntry> createState() => _CodeEntryState();
}

class _CodeEntryState extends State<CodeEntry>
    with SingleTickerProviderStateMixin {
  var _code = '';
  var _busy = false;
  String? _error;

  late final _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  void _onDigit(String digit) {
    if (_code.length >= widget.length) return;
    setState(() {
      _code += digit;
      _error = null;
    });
    if (_code.length == widget.length) _submit();
  }

  Future<void> _submit() async {
    setState(() => _busy = true);
    try {
      await widget.onCompleted(_code);
      if (mounted) setState(() => _code = '');
    } on AppException catch (e) {
      await HapticFeedback.vibrate();
      if (!mounted) return;
      setState(() {
        _code = '';
        _error = e.message;
      });
      await _shake.forward(from: 0);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final kora = context.kora;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _shake,
          builder: (context, child) => Transform.translate(
            // Four damped side-to-side swings; zero at rest.
            offset: Offset(
              12 * (1 - _shake.value) * sin(_shake.value * pi * 8),
              0,
            ),
            child: child,
          ),
          child: Semantics(
            label: '${_code.length} of ${widget.length} digits entered',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < widget.length; i++)
                  widget.obscure
                      ? _Dot(filled: i < _code.length)
                      : _DigitBox(
                          digit: i < _code.length ? _code[i] : null,
                          active: i == _code.length,
                        ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 40,
          child: _busy
              ? const Center(
                  child: SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                )
              : Text(
                  _error ?? widget.hint ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _error != null ? AppColors.error : kora.muted,
                  ),
                ),
        ),
        const SizedBox(height: 8),
        NumberPad(
          enabled: !_busy,
          leading: widget.leading,
          onDigit: _onDigit,
          onBackspace: () => setState(() {
            if (_code.isNotEmpty) _code = _code.substring(0, _code.length - 1);
          }),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.filled});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    final color = context.kora.debit;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? color : Colors.transparent,
        border: Border.all(color: color, width: 2),
      ),
    );
  }
}

class _DigitBox extends StatelessWidget {
  const _DigitBox({required this.digit, required this.active});

  final String? digit;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final kora = context.kora;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 44,
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kora.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active ? kora.debit : kora.border,
          width: active ? 2 : 1,
        ),
      ),
      child: Text(
        digit ?? '',
        style: context.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
