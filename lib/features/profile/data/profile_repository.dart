import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/database.dart';
import '../../../core/data/mappers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/network/mock_network.dart';
import '../../account/domain/account.dart';
import '../domain/customer_profile.dart';

abstract interface class ProfileRepository {
  Stream<CustomerProfile?> watchProfile();

  /// Records the phone number verified during sign-up.
  Future<void> setPhone(String phone);

  /// Verifies the NIN and address and moves the account to Tier 3.
  Future<void> upgradeToTier3({required String nin, required String address});
}

class MockProfileRepository implements ProfileRepository {
  MockProfileRepository(this._db, this._network);

  final AppDatabase _db;
  final MockNetwork _network;

  @override
  Stream<CustomerProfile?> watchProfile() => (_db.select(
    _db.customerProfiles,
  )..limit(1)).watchSingleOrNull().map((row) => row?.toDomain());

  @override
  Future<void> setPhone(String phone) async {
    await _db
        .update(_db.customerProfiles)
        .write(CustomerProfilesCompanion(phone: Value(phone)));
  }

  @override
  Future<void> upgradeToTier3({
    required String nin,
    required String address,
  }) async {
    if (!RegExp(r'^\d{11}$').hasMatch(nin)) {
      throw const ValidationException('Your NIN is 11 digits.');
    }
    if (address.trim().length < 10) {
      throw const ValidationException('Enter your full home address.');
    }
    // A real NIMC check takes a moment; the mock network adds that delay.
    await _network.roundTrip();
    await _db.transaction(() async {
      await _db
          .update(_db.customerProfiles)
          .write(
            CustomerProfilesCompanion(
              ninLast4: Value(nin.substring(7)),
              address: Value(address.trim()),
            ),
          );
      await _db
          .update(_db.accounts)
          .write(AccountsCompanion(kycTier: Value(KycTier.tier3.level)));
    });
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => MockProfileRepository(
    ref.watch(databaseProvider),
    ref.watch(mockNetworkProvider),
  ),
);

final customerProfileProvider = StreamProvider<CustomerProfile?>(
  (ref) => ref.watch(profileRepositoryProvider).watchProfile(),
);
