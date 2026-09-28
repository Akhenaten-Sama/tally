import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/brand/brand.dart';
import '../core/config/app_config.dart';
import '../core/widgets/coming_soon.dart';
import '../core/security/biometrics.dart';
import '../features/auth/data/auth_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/onboarding/biometrics_screen.dart';
import '../features/auth/presentation/onboarding/name_screen.dart';
import '../features/auth/presentation/onboarding/otp_screen.dart';
import '../features/auth/presentation/onboarding/phone_screen.dart';
import '../features/auth/presentation/onboarding/secret_steps.dart';
import '../features/auth/presentation/welcome_screen.dart';
import '../features/bills/data/recent_billers.dart';
import '../features/bills/presentation/airtime_screen.dart';
import '../features/bills/presentation/bills_screen.dart';
import '../features/bills/presentation/cable_screen.dart';
import '../features/bills/presentation/electricity_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/mortgage/domain/mortgage.dart';
import '../features/mortgage/presentation/application_screen.dart';
import '../features/mortgage/presentation/apply_screen.dart';
import '../features/mortgage/presentation/calculator_screen.dart';
import '../features/mortgage/presentation/mortgage_screen.dart';
import '../features/mortgage/presentation/products_screen.dart';
import '../features/mortgage/presentation/schedule_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/profile/presentation/account_limits_screen.dart';
import '../features/profile/presentation/change_code_screen.dart';
import '../features/profile/presentation/personal_details_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/profile/presentation/upgrade_tier_screen.dart';
import '../features/statement/presentation/statement_screen.dart';
import '../features/transactions/presentation/history_screen.dart';
import '../features/transactions/presentation/transaction_detail_screen.dart';
import '../features/transfers/presentation/amount_screen.dart';
import '../features/transfers/presentation/recipient_screen.dart';
import '../features/transfers/presentation/transfer_status_screen.dart';
import 'app_shell.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  // GoRouter needs a Listenable to re-run redirects when the session changes.
  final status = ValueNotifier(ref.read(authControllerProvider).status);
  ref.listen(
    authControllerProvider.select((a) => a.status),
    (_, next) => status.value = next,
  );

  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppConfig.initialRoute,
    refreshListenable: status,
    // "Locked" is not a route: the lock screen covers the app instead (see
    // AppLockGuard), so the user returns to exactly where they were.
    redirect: (context, state) {
      final location = state.matchedLocation;
      final inSignUp =
          location == Routes.welcome || location.startsWith(Routes.onboarding);
      if (status.value == AuthStatus.signedOut) {
        return inSignUp ? null : Routes.welcome;
      }
      return inSignUp ? Routes.home : null;
    },
    routes: [
      GoRoute(path: Routes.welcome, builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: Routes.onboardingPhone,
        builder: (_, _) => const PhoneScreen(),
      ),
      GoRoute(path: Routes.onboardingOtp, builder: (_, _) => const OtpScreen()),
      GoRoute(
        path: Routes.onboardingName,
        builder: (_, _) => const NameScreen(),
      ),
      GoRoute(
        path: Routes.onboardingPasscode,
        builder: (_, _) => const PasscodeStep(),
      ),
      GoRoute(path: Routes.onboardingPin, builder: (_, _) => const PinStep()),
      GoRoute(
        path: Routes.onboardingBiometrics,
        builder: (_, state) =>
            BiometricsScreen(kind: state.extra! as BiometricKind),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (_, _) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'transfer/:id',
                    // Full screen, above the bottom navigation bar.
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, state) =>
                        TransferStatusScreen(id: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.history,
                builder: (_, _) => const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              if (Brand.current.hasMortgages)
                GoRoute(
                  path: Routes.mortgage,
                  builder: (_, _) => const MortgageScreen(),
                  routes: [
                    // Full screen, above the bottom navigation bar.
                    GoRoute(
                      path: 'schedule',
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (_, _) => const ScheduleScreen(),
                    ),
                    GoRoute(
                      path: 'products',
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (_, _) => const ProductsScreen(),
                      routes: [
                        GoRoute(
                          path: 'calculator',
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (_, state) => CalculatorScreen(
                            product: state.extra! as MortgageProduct,
                          ),
                        ),
                      ],
                    ),
                    GoRoute(
                      path: 'apply',
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (_, state) =>
                          ApplyScreen(quote: state.extra! as MortgageQuote),
                    ),
                    GoRoute(
                      path: 'applications/:id',
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (_, state) =>
                          ApplicationScreen(id: state.pathParameters['id']!),
                    ),
                  ],
                )
              else
                GoRoute(
                  path: Routes.savings,
                  builder: (_, _) => const ComingSoonScreen(
                    title: 'Savings',
                    icon: Icons.savings_outlined,
                    milestone: 4,
                  ),
                ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (_, _) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'details',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, _) => const PersonalDetailsScreen(),
                  ),
                  GoRoute(
                    path: 'limits',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, _) => const AccountLimitsScreen(),
                    routes: [
                      GoRoute(
                        path: 'upgrade',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (_, _) => const UpgradeTierScreen(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'change-pin',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, _) =>
                        const ChangeCodeScreen(kind: SecretKind.pin),
                  ),
                  GoRoute(
                    path: 'change-passcode',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, _) =>
                        const ChangeCodeScreen(kind: SecretKind.passcode),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.send,
        builder: (_, _) => const RecipientScreen(),
        routes: [
          GoRoute(path: 'amount', builder: (_, _) => const AmountScreen()),
        ],
      ),
      GoRoute(
        path: '/transactions/:id',
        builder: (_, state) =>
            TransactionDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.statement,
        builder: (_, _) => const StatementScreen(),
      ),
      GoRoute(
        path: Routes.notifications,
        builder: (_, _) => const NotificationsScreen(),
      ),
      GoRoute(
        path: Routes.bills,
        builder: (_, _) => const BillsScreen(),
        routes: [
          GoRoute(
            path: 'airtime',
            builder: (_, state) =>
                AirtimeScreen(prefill: state.extra as BillPrefill?),
          ),
          GoRoute(
            path: 'electricity',
            builder: (_, state) =>
                ElectricityScreen(prefill: state.extra as BillPrefill?),
          ),
          GoRoute(
            path: 'cable',
            builder: (_, state) =>
                CableScreen(prefill: state.extra as BillPrefill?),
          ),
        ],
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    status.dispose();
  });
  return router;
});
