import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../features/bills/domain/billers.dart';
import '../errors/app_exception.dart';

/// Real meter and smartcard verification through VTpass "merchant verify".
/// Read-only: it never buys anything.
class VtpassBillerLookup {
  VtpassBillerLookup(
    this._client, {
    required this._apiKey,
    required this._secretKey,
    required bool sandbox,
  }) : _host = sandbox ? 'sandbox.vtpass.com' : 'vtpass.com';

  final http.Client _client;
  final String _apiKey;
  final String _secretKey;
  final String _host;

  static const _timeout = Duration(seconds: 20);

  Future<BillCustomer> verifyMeter({
    required Disco disco,
    required MeterType type,
    required String meterNumber,
  }) => _verify(
    serviceId: disco.vtpassServiceId,
    billersCode: meterNumber,
    type: type.name,
    notFound: "We couldn't find that meter. Check the number and company.",
  );

  Future<BillCustomer> verifySmartcard({
    required CableProvider provider,
    required String smartcardNumber,
  }) => _verify(
    serviceId: provider.vtpassServiceId,
    billersCode: smartcardNumber,
    notFound: "We couldn't find that smartcard. Check the number.",
  );

  Future<BillCustomer> _verify({
    required String serviceId,
    required String billersCode,
    required String notFound,
    String? type,
  }) async {
    final http.Response response;
    try {
      response = await _client
          .post(
            Uri.https(_host, '/api/merchant-verify'),
            headers: {
              'api-key': _apiKey,
              'secret-key': _secretKey,
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'billersCode': billersCode,
              'serviceID': serviceId,
              'type': ?type,
            }),
          )
          .timeout(_timeout);
    } on Exception {
      throw const NetworkException();
    }

    final Map<String, dynamic>? body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      throw AccountNotFoundException(notFound);
    }
    if (const {401, 403, 429}.contains(response.statusCode)) {
      throw const LookupUnavailableException('Biller lookup unavailable');
    }

    final content = body['content'];
    if (content is! Map<String, dynamic> ||
        content['error'] != null ||
        content['WrongBillersCode'] == true) {
      throw AccountNotFoundException(notFound);
    }
    final name = content['Customer_Name'];
    if (name is! String || name.trim().isEmpty) {
      throw AccountNotFoundException(notFound);
    }
    final address = content['Address'];
    return BillCustomer(
      name: name.trim().toUpperCase(),
      address: address is String && address.trim().isNotEmpty
          ? address.trim()
          : null,
    );
  }
}
