import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kora/core/data/database.dart';
import 'package:kora/core/data/demo_seeder.dart';
import 'package:kora/core/errors/app_exception.dart';
import 'package:kora/core/network/mock_network.dart';
import 'package:kora/features/account/domain/account.dart';
import 'package:kora/features/profile/data/profile_repository.dart';
import 'package:kora/features/profile/domain/customer_profile.dart';

void main() {
  late AppDatabase db;
  late MockProfileRepository profiles;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await DemoSeeder(db).ensureSeeded();
    profiles = MockProfileRepository(
      db,
      MockNetwork(MockNetworkConfig.instant),
    );
  });

  tearDown(() => db.close());

  Future<int> tier() async =>
      (await db.select(db.accounts).getSingle()).kycTier;

  test('the demo customer has a BVN on file and no NIN yet', () async {
    final profile = (await profiles.watchProfile().first)!;
    expect(profile.bvnLast4, DemoSeeder.bvnLast4);
    expect(profile.ninLast4, isNull);
    expect(CustomerProfile.mask(profile.bvnLast4), '•••••••4821');
  });

  test('upgrading stores only the last four NIN digits', () async {
    await profiles.upgradeToTier3(
      nin: '12345678901',
      address: '5 Allen Avenue, Ikeja, Lagos',
    );
    final profile = (await profiles.watchProfile().first)!;
    expect(profile.ninLast4, '8901');
    expect(profile.address, '5 Allen Avenue, Ikeja, Lagos');
    expect(await tier(), KycTier.tier3.level);
  });

  test('rejects a malformed NIN without changing the tier', () async {
    await expectLater(
      profiles.upgradeToTier3(nin: '1234', address: '5 Allen Avenue, Ikeja'),
      throwsA(isA<ValidationException>()),
    );
    expect(await tier(), KycTier.tier2.level);
  });
}
