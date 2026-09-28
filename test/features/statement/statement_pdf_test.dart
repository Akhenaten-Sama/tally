import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tally/core/money/money.dart';
import 'package:tally/features/account/domain/account.dart';
import 'package:tally/features/profile/domain/customer_profile.dart';
import 'package:tally/features/statement/data/statement_pdf.dart';
import 'package:tally/features/statement/domain/statement.dart';

import 'statement_test.dart' show txn;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('renders a valid PDF with a transaction table', () async {
    final statement = Statement.build(
      transactions: [
        for (var i = 1; i <= 40; i++)
          txn(
            'T$i',
            DateTime(2026, 9, 1 + i % 28),
            150000 * i,
            credit: i.isEven,
          ),
      ],
      currentBalance: const Money(1278900000),
      from: DateTime(2026, 9, 1),
      to: DateTime(2026, 9, 30),
    );
    final bytes = await buildStatementPdf(
      statement: statement,
      account: const Account(
        id: 'a',
        holderName: 'Olalekan Israel Efunkunle',
        accountNumber: '8123456790',
        balance: Money(1278900000),
        tier: KycTier.tier2,
      ),
      profile: CustomerProfile(
        phone: '08031234567',
        address: '12 Admiralty Way, Lekki Phase 1, Lagos',
        memberSince: DateTime(2024, 3),
      ),
    );

    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    final out = Platform.environment['STATEMENT_PDF_OUT'];
    if (out != null) await File(out).writeAsBytes(bytes);
  });
}
