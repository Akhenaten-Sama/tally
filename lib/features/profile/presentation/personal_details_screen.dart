import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/brand/brand.dart';
import '../../../core/theme/tally_colors.dart';
import '../../../core/widgets/error_view.dart';
import '../../account/data/account_repository.dart';
import '../../auth/domain/phone_number.dart';
import '../data/profile_repository.dart';
import '../domain/customer_profile.dart';

final _date = DateFormat('d MMMM yyyy');
final _monthYear = DateFormat('MMMM yyyy');

class PersonalDetailsScreen extends ConsumerWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(customerProfileProvider);
    final account = ref.watch(primaryAccountProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Personal details')),
      body: switch (profile) {
        AsyncData(value: final CustomerProfile p) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            _Group(
              rows: [
                ('Full name', account?.holderName ?? ''),
                ('Phone number', _phone(p.phone)),
                ('Email', p.email ?? 'Not added'),
                (
                  'Date of birth',
                  p.dateOfBirth == null
                      ? 'Not added'
                      : _date.format(p.dateOfBirth!),
                ),
                ('Home address', p.address ?? 'Not added'),
              ],
            ),
            const SizedBox(height: 16),
            _Group(
              rows: [
                ('BVN', CustomerProfile.mask(p.bvnLast4)),
                ('NIN', CustomerProfile.mask(p.ninLast4)),
                ('Customer since', _monthYear.format(p.memberSince)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: context.tally.muted,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'These details come from your BVN and identity checks. '
                    'To change them, visit any ${Brand.current.shortName} '
                    'branch with a valid ID.',
                    style: TextStyle(color: context.tally.muted),
                  ),
                ),
              ],
            ),
          ],
        ),
        AsyncData() => const Center(child: Text('No profile found')),
        AsyncError(:final error) => Center(child: ErrorView(error: error)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  static String _phone(String raw) => PhoneNumber.tryParse(raw)?.display ?? raw;
}

class _Group extends StatelessWidget {
  const _Group({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final tally = context.tally;
    return Container(
      decoration: BoxDecoration(
        color: tally.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: tally.border),
      ),
      child: Column(
        children: [
          for (final (i, (label, value)) in rows.indexed) ...[
            if (i > 0) const Divider(indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: tally.muted)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      value,
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
