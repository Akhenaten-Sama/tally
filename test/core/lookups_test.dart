import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tally/core/errors/app_exception.dart';
import 'package:tally/core/lookups/paystack_name_enquiry.dart';
import 'package:tally/core/lookups/vtpass_biller_lookup.dart';
import 'package:tally/features/bills/domain/billers.dart';

http.Response json(Object body, int status) =>
    http.Response(jsonEncode(body), status);

void main() {
  group('Paystack name enquiry', () {
    test('sends the key and returns the upper-cased name', () async {
      late http.Request sent;
      final paystack = PaystackNameEnquiry(
        MockClient((request) async {
          sent = request;
          return json({
            'status': true,
            'data': {'account_name': 'Adaeze Okafor'},
          }, 200);
        }),
        'sk_test_123',
      );

      final name = await paystack.resolve(
        bankCode: '058',
        accountNumber: '0123456789',
      );

      expect(name, 'ADAEZE OKAFOR');
      expect(sent.headers['Authorization'], 'Bearer sk_test_123');
      expect(sent.url.queryParameters, {
        'account_number': '0123456789',
        'bank_code': '058',
      });
    });

    test('maps an unresolvable account to AccountNotFound', () async {
      final paystack = PaystackNameEnquiry(
        MockClient(
          (_) async => json({
            'status': false,
            'message': 'Could not resolve account name.',
          }, 422),
        ),
        'k',
      );
      await expectLater(
        paystack.resolve(bankCode: '058', accountNumber: '0000000000'),
        throwsA(isA<AccountNotFoundException>()),
      );
    });

    test('maps connection failures to NetworkException', () async {
      final paystack = PaystackNameEnquiry(
        MockClient((_) async => throw http.ClientException('offline')),
        'k',
      );
      await expectLater(
        paystack.resolve(bankCode: '058', accountNumber: '0123456789'),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('VTpass biller lookup', () {
    VtpassBillerLookup lookup(MockClientHandler handler) => VtpassBillerLookup(
      MockClient(handler),
      apiKey: 'api',
      secretKey: 'secret',
      sandbox: true,
    );

    test('verifies a prepaid meter against the sandbox', () async {
      late http.Request sent;
      final customer =
          await lookup((request) async {
            sent = request;
            return json({
              'code': '000',
              'content': {
                'Customer_Name': 'Testmeter1',
                'Address': 'Abule Egba, Lagos',
                'WrongBillersCode': false,
              },
            }, 200);
          }).verifyMeter(
            disco: Disco.ikeja,
            type: MeterType.prepaid,
            meterNumber: '1111111111111',
          );

      expect(customer.name, 'TESTMETER1');
      expect(customer.address, 'Abule Egba, Lagos');
      expect(sent.url.host, 'sandbox.vtpass.com');
      expect(sent.headers['api-key'], 'api');
      expect(jsonDecode(sent.body), {
        'billersCode': '1111111111111',
        'serviceID': 'ikeja-electric',
        'type': 'prepaid',
      });
    });

    test('a wrong smartcard is AccountNotFound', () async {
      await expectLater(
        lookup(
          (_) async => json({
            'code': '000',
            'content': {'error': 'This IUC is not correct'},
          }, 200),
        ).verifySmartcard(
          provider: CableProvider.dstv,
          smartcardNumber: '1212121212',
        ),
        throwsA(isA<AccountNotFoundException>()),
      );
    });
  });
}
