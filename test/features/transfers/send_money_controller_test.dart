import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tally/core/data/database.dart';
import 'package:tally/core/data/demo_seeder.dart';
import 'package:tally/core/errors/app_exception.dart';
import 'package:tally/core/network/mock_network.dart';
import 'package:tally/features/auth/data/auth_controller.dart';
import 'package:tally/features/auth/data/transaction_pin_repository.dart';
import 'package:tally/features/transfers/domain/bank.dart';
import 'package:tally/features/transfers/presentation/send_money_controller.dart';

/// Checks the PIN without touching the network, so going "offline" in a
/// test only affects the transfer itself.
class _OfflinePinCheck implements TransactionPinRepository {
  @override
  Future<void> verify(String pin) async {
    if (pin != DemoCredentials.pin) {
      throw IncorrectPinException(2);
    }
  }
}

void main() {
  late AppDatabase db;
  late MockNetwork network;
  late ProviderContainer container;

  SendMoneyController controller() =>
      container.read(sendMoneyProvider.notifier);

  Future<int> balance() async =>
      (await db.select(db.accounts).getSingle()).balanceKobo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await DemoSeeder(db).ensureSeeded();
    network = MockNetwork(MockNetworkConfig.instant);
    container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        databaseProvider.overrideWithValue(db),
        mockNetworkProvider.overrideWithValue(network),
        transactionPinRepositoryProvider.overrideWithValue(_OfflinePinCheck()),
      ],
    );
    // Keep the auto-disposed flow alive for the whole test.
    container.listen(sendMoneyProvider, (_, _) {});

    controller()
      ..selectBank(Bank.byCode('058'))
      ..setAccountNumber('0123456789')
      ..setAccountName('OKAFOR CHINEDU');
    for (final key in '5000'.split('')) {
      controller().pressKey(key);
    }
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test('a wrong PIN sends nothing', () async {
    final before = await balance();
    await expectLater(
      controller().submitWithPin('0000'),
      throwsA(isA<IncorrectPinException>()),
    );
    expect(await balance(), before);
  });

  test('retrying after a network drop reuses the reference', () async {
    final before = await balance();

    network.config = network.config.copyWith(offline: true);
    await expectLater(
      controller().submitWithPin('1234'),
      throwsA(isA<NetworkException>()),
    );
    final reference = container.read(sendMoneyProvider).reference;
    expect(reference, isNotNull);

    network.config = network.config.copyWith(offline: false);
    final first = await controller().submitWithPin('1234');
    final retry = await controller().submitWithPin('1234');

    expect(first.reference, reference);
    expect(retry.id, first.id);
    expect(await balance(), before - first.total.kobo);
  });

  test('changing the amount starts a new transfer', () async {
    final first = await controller().submitWithPin('1234');
    controller().pressKey('0');
    final second = await controller().submitWithPin('1234');

    expect(second.reference, isNot(first.reference));
  });
}
