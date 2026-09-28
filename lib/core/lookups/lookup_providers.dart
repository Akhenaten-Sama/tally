import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'lookup_keys.dart';
import 'paystack_name_enquiry.dart';
import 'vtpass_biller_lookup.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

/// Null when no Paystack key was provided: the app falls back to the
/// simulated name enquiry.
final paystackNameEnquiryProvider = Provider<PaystackNameEnquiry?>(
  (ref) => LookupKeys.hasPaystack
      ? PaystackNameEnquiry(
          ref.watch(httpClientProvider),
          LookupKeys.paystackSecret,
        )
      : null,
);

/// Null when no VTpass keys were provided: the app falls back to the
/// simulated meter and smartcard lookups.
final vtpassBillerLookupProvider = Provider<VtpassBillerLookup?>(
  (ref) => LookupKeys.hasVtpass
      ? VtpassBillerLookup(
          ref.watch(httpClientProvider),
          apiKey: LookupKeys.vtpassApiKey,
          secretKey: LookupKeys.vtpassSecretKey,
          sandbox: LookupKeys.vtpassSandbox,
        )
      : null,
);
