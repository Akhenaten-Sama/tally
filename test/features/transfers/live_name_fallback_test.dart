import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tally/core/data/database.dart';
import 'package:tally/core/lookups/paystack_name_enquiry.dart';
import 'package:tally/core/network/mock_network.dart';
import 'package:tally/features/transfers/data/mock_directory.dart';
import 'package:tally/features/transfers/data/mock_transfer_repository.dart';
import 'package:tally/features/transfers/domain/bank.dart';

void main() {
  test(
    'falls back to the simulated name when Paystack is rate limited',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      final repository = MockTransferRepository(
        db,
        MockNetwork(MockNetworkConfig.instant),
        liveNameEnquiry: PaystackNameEnquiry(
          MockClient(
            (_) async => http.Response(
              jsonEncode({'status': false, 'message': 'daily limit'}),
              429,
            ),
          ),
          'k',
        ),
      );
      final bank = Bank.byCode('058');

      final name = await repository.resolveAccountName(
        bank: bank,
        accountNumber: '0123456781',
      );

      expect(name, mockAccountName(bank, '0123456781'));
      repository.dispose();
      await db.close();
    },
  );
}
