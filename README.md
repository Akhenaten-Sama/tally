# Tally

A Nigerian neobank app built in Flutter: send money to any bank, pay bills and grow your savings.

Tally is a portfolio project. It has no real backend. It runs against a local mock of a bank backend that behaves like the real thing, including network latency, failed transfers, pending transfers that settle later, and reversals. The APK works on its own, and every loading, error and edge state in the UI can be triggered on purpose.

## Highlights

- **Money is never a double.** Every amount is integer kobo ([`Money`](lib/core/money/money.dart)).
- **Idempotent transfers.** Each transfer carries a client-generated reference. Retrying a request after a network drop never debits twice.
- **Debit first, then reverse on failure.** Refunds are separate reversal entries, so the history shows what actually happened ([`MockTransferRepository`](lib/features/transfers/data/mock_transfer_repository.dart)).
- **Reconciliation.** Transfers still pending when the app was killed are settled on the next launch.
- **Credentials hashed, never stored raw.** The passcode and PIN are kept as salted SHA-256 hashes in the Keychain/Keystore and compared in constant time.
- **Lock screen over the navigator.** Auto-lock and unlock never lose your place, even mid-transfer. Balances are hidden in the app switcher.
- **PIN with lockout.** Three wrong attempts lock transfers for a minute. The check is treated as server-side.
- **CBN KYC tiers.** Daily limits are enforced across all of the day's transfers.
- **NIP details.** Name enquiry before confirming, standard NIP fees, and free Tally-to-Tally transfers.
- **Developer tools in the app.** Long-press the avatar on Home, or go to Profile → Developer tools, to go offline, change latency, force transfers to succeed, fail or stay pending, and reset the demo data.

## White-label brands

Name, logo, colours, font, copy and app icon come from one [`Brand`](lib/core/brand/brand.dart) config, chosen at build time:

```sh
flutter run --dart-define=BRAND=cmb     # Cooperative Mortgage Bank concept
scripts/install_ios.sh cmb              # release build on a connected iPhone
```

Each brand installs as a separate app with its own name, icon and bundle ID.

Brands with `hasMortgages` (CMB) swap the Savings tab for **Mortgage**: loan balance and progress, next repayment (paid with PIN or Face ID), a full amortisation schedule, product catalogue, repayment calculator with an affordability check, and an application tracker. Amortisation is computed in integer kobo and the schedule ends at exactly ₦0.00.

## Stack

| Concern | Choice |
|---|---|
| State | Riverpod 3 |
| Navigation | go_router with a `StatefulShellRoute` and an auth redirect |
| Local data | Drift (SQLite), reactive streams |
| Models | freezed |
| Security | flutter_secure_storage, local_auth |

## Structure

```
lib/
  app/        router, shell, app widget
  core/       money, theme, database, mock network, errors, shared widgets
  features/
    <feature>/
      domain/        models and business rules (no Flutter imports)
      data/          repository interface + mock implementation
      presentation/  screens and widgets
```

Each repository is an interface with a `Mock…` implementation. Adding a real API only means writing a new implementation and changing one provider.

## Running

```sh
flutter pub get
dart run build_runner build

flutter run                           # demo flavor: starts on the welcome screen
flutter run --dart-define=FLAVOR=dev  # dev flavor: starts signed in
flutter run --dart-define=FLAVOR=dev --dart-define=INITIAL_ROUTE=/send  # open a specific screen

flutter test
```

## Roadmap

- [x] **M1:** Scaffold, design system, mock backend, home, history, debug tools
- [x] **M2:** Onboarding (phone → OTP → name → passcode → PIN → Face ID), lock screen, auto-lock, app-switcher privacy cover
- [x] **M3:** Send money (keypad → bank and account → name enquiry → PIN → receipt shared as an image), transaction detail
- [x] **M4 (bills):** Airtime and data (network auto-detected from the number), electricity (meter lookup, prepaid token and kWh), cable TV (smartcard lookup, packages), all through a shared ledger with idempotency and refunds
- [x] **Profile:** personal details (identity numbers masked, only the last 4 digits stored), account limits, Tier 3 upgrade (NIN and address), change PIN or passcode
- [x] **Polish:** liquid glass balance card, notifications derived from account activity (with an unread badge), per-brand iOS launch screen, PDF account statements that reconcile to the live balance
- [ ] **M4 (rest):** Savings goals (Home Ownership Savings)
- [ ] **M5:** Offline cache and transfer queue, golden and integration tests, CI, demo video
