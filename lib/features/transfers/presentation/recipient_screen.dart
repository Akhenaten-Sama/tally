import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/theme/tally_colors.dart';
import '../../../core/widgets/initials_avatar.dart';
import '../data/transfer_repository.dart';
import '../domain/transfer.dart';
import 'send_money_controller.dart';
import 'widgets/bank_picker.dart';

/// Step 1: who is the money going to?
class RecipientScreen extends ConsumerStatefulWidget {
  const RecipientScreen({super.key});

  @override
  ConsumerState<RecipientScreen> createState() => _RecipientScreenState();
}

class _RecipientScreenState extends ConsumerState<RecipientScreen> {
  final _accountNumber = TextEditingController();

  @override
  void dispose() {
    _accountNumber.dispose();
    super.dispose();
  }

  void _useBeneficiary(Beneficiary beneficiary) {
    ref.read(sendMoneyProvider.notifier).useBeneficiary(beneficiary);
    _accountNumber.text = beneficiary.accountNumber;
    context.push(Routes.sendAmount);
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(sendMoneyProvider);
    final controller = ref.read(sendMoneyProvider.notifier);
    final beneficiaries = ref.watch(beneficiariesProvider).value ?? const [];

    // Name enquiry runs as soon as there's a bank and 10 digits.
    final bank = draft.bank;
    final lookup = bank != null && draft.hasAccountNumber
        ? ref.watch(accountNameLookupProvider((bank, draft.accountNumber)))
        : null;
    final resolvedName = draft.accountName ?? lookup?.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Send money')),
      // The button lives in the body (not bottomNavigationBar) so it rises
      // with the keyboard. Tapping outside a field closes the keyboard, since
      // the iOS number pad has no "Done" key.
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  _BankField(
                    bankName: bank?.name,
                    onTap: () async {
                      final picked = await showBankPicker(
                        context,
                        selected: bank,
                      );
                      if (picked != null) controller.selectBank(picked);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _accountNumber,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,
                    style: const TextStyle(letterSpacing: 1.5),
                    decoration: const InputDecoration(
                      labelText: 'Account number',
                      counterText: '',
                    ),
                    onChanged: (value) {
                      controller.setAccountNumber(value);
                      // All 10 digits in: close the keyboard so the name and the
                      // Continue button are visible while the lookup runs.
                      if (value.length == 10) FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(height: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _LookupStatus(
                      key: ValueKey((
                        lookup?.isLoading,
                        resolvedName,
                        lookup?.error,
                      )),
                      name: resolvedName,
                      isLoading:
                          draft.accountName == null &&
                          (lookup?.isLoading ?? false),
                      error: draft.accountName == null ? lookup?.error : null,
                      onRetry: bank == null
                          ? null
                          : () => ref.invalidate(
                              accountNameLookupProvider((
                                bank,
                                draft.accountNumber,
                              )),
                            ),
                    ),
                  ),
                  if (beneficiaries.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    Text(
                      'Recent',
                      style: context.textTheme.titleSmall?.copyWith(
                        color: context.tally.muted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    for (final b in beneficiaries.take(8))
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: InitialsAvatar(name: b.name),
                        title: Text(
                          b.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text('${b.bank.name} · ${b.accountNumber}'),
                        onTap: () => _useBeneficiary(b),
                      ),
                  ],
                ],
              ),
            ),
            SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: FilledButton(
                onPressed: resolvedName == null
                    ? null
                    : () {
                        controller.setAccountName(resolvedName);
                        context.push(Routes.sendAmount);
                      },
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BankField extends StatelessWidget {
  const _BankField({required this.bankName, required this.onTap});

  final String? bankName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Bank',
        suffixIcon: Icon(Icons.expand_more_rounded),
      ),
      isEmpty: bankName == null,
      child: Text(bankName ?? ''),
    ),
  );
}

class _LookupStatus extends StatelessWidget {
  const _LookupStatus({
    super.key,
    required this.name,
    required this.isLoading,
    required this.error,
    required this.onRetry,
  });

  final String? name;
  final bool isLoading;
  final Object? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final tally = context.tally;
    if (isLoading) {
      return Row(
        children: [
          const SizedBox.square(
            dimension: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Text('Verifying account…', style: TextStyle(color: tally.muted)),
        ],
      );
    }
    if (name != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: tally.credit.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.verified_rounded, size: 18, color: tally.credit),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name!,
                style: TextStyle(
                  color: tally.credit,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (error != null) {
      final message = error is AppException
          ? (error! as AppException).message
          : "We couldn't verify this account.";
      return Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
          // Only a network failure is worth retrying as-is.
          if (error is NetworkException && onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
