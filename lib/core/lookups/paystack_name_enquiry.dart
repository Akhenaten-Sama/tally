import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../errors/app_exception.dart';

/// Real account-name lookup through Paystack's "resolve account number"
/// endpoint. Read-only: it never moves money.
class PaystackNameEnquiry {
  PaystackNameEnquiry(this._client, this._secretKey);

  final http.Client _client;
  final String _secretKey;

  /// Names already resolved this session, so repeat lookups of the same
  /// account don't spend quota (test keys allow only 3 a day).
  final _cache = <String, String>{};

  static const _timeout = Duration(seconds: 15);

  Future<String> resolve({
    required String bankCode,
    required String accountNumber,
  }) async {
    final cacheKey = '$bankCode:$accountNumber';
    final cached = _cache[cacheKey];
    if (cached != null) return cached;

    final uri = Uri.https('api.paystack.co', '/bank/resolve', {
      'account_number': accountNumber,
      'bank_code': bankCode,
    });

    final http.Response response;
    try {
      response = await _client
          .get(uri, headers: {'Authorization': 'Bearer $_secretKey'})
          .timeout(_timeout);
    } on Exception {
      throw const NetworkException();
    }

    final body = _decode(response.body);
    final name = (body?['data'] as Map<String, dynamic>?)?['account_name'];
    if (response.statusCode == 200 &&
        body?['status'] == true &&
        name is String) {
      return _cache[cacheKey] = name.toUpperCase();
    }
    throw switch (response.statusCode) {
      // Quota or key problems say nothing about the account itself.
      401 || 403 || 429 => LookupUnavailableException(
        body?['message'] as String? ?? 'Lookup unavailable',
      ),
      _ => const AccountNotFoundException(),
    };
  }

  static Map<String, dynamic>? _decode(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } on FormatException {
      return null;
    }
  }
}
