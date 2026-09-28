import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/brand/brand.dart';
import '../../../core/config/app_config.dart';
import '../../../core/debug/debug_menu.dart';
import '../../../core/security/biometrics.dart';
import '../../../core/theme/kora_colors.dart';
import '../../../core/widgets/initials_avatar.dart';
import '../../account/data/account_repository.dart';
import '../../account/domain/account.dart';
import '../../auth/data/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _toggleBiometrics(
    WidgetRef ref,
    BiometricKind kind,
    bool enable,
  ) async {
    // Prove it's the owner before turning it on.
    if (enable &&
        !await ref
            .read(biometricsProvider)
            .authenticate(
              'Turn on ${kind.label} for ${Brand.current.shortName}',
            )) {
      return;
    }
    await ref
        .read(authControllerProvider.notifier)
        .setBiometricsEnabled(enable);
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out?'),
        content: Text(
          "You'll need to log in again to use "
          '${Brand.current.shortName} on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(authControllerProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(primaryAccountProvider).value;
    final auth = ref.watch(authControllerProvider);
    final kind = ref.watch(biometricKindProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          if (account != null) _Header(account: account),
          const _Section('Account'),
          _Tile(
            icon: Icons.badge_outlined,
            title: 'Personal details',
            subtitle: 'Name, phone, email, address, BVN',
            onTap: () => context.push(Routes.personalDetails),
          ),
          if (account != null)
            _Tile(
              icon: Icons.speed_rounded,
              title: 'Account limits',
              subtitle:
                  '${account.tier.label} · up to '
                  '${account.tier.dailyLimit.format(showKobo: false)} a day',
              onTap: () => context.push(Routes.accountLimits),
            ),
          _Tile(
            icon: Icons.receipt_long_outlined,
            title: 'Account statement',
            subtitle: 'Download a PDF for any period',
            onTap: () => context.push(Routes.statement),
          ),
          const _Section('Security'),
          if (kind != null)
            SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              secondary: Icon(kind.icon),
              title: Text('Use ${kind.label}'),
              subtitle: const Text('Unlock the app and approve payments'),
              value: auth.biometricsEnabled,
              onChanged: (enable) => _toggleBiometrics(ref, kind, enable),
            ),
          _Tile(
            icon: Icons.pin_outlined,
            title: 'Change transaction PIN',
            onTap: () => context.push(Routes.changePin),
          ),
          _Tile(
            icon: Icons.password_rounded,
            title: 'Change passcode',
            onTap: () => context.push(Routes.changePasscode),
          ),
          _Tile(
            icon: Icons.lock_outline_rounded,
            title: 'Lock app',
            onTap: ref.read(authControllerProvider.notifier).lock,
          ),
          if (AppConfig.debugMenuEnabled && Brand.current.showDemoHints) ...[
            const _Section('Developer'),
            _Tile(
              icon: Icons.developer_mode_rounded,
              title: 'Developer tools',
              subtitle: 'Latency, failures, offline, auto-lock',
              onTap: () => showDebugMenu(context),
            ),
          ],
          const SizedBox(height: 16),
          _Tile(
            icon: Icons.logout_rounded,
            title: 'Sign out',
            color: AppColors.error,
            onTap: () => _signOut(context, ref),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '${Brand.current.name} · version 1.0.0',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.kora.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    final kora = context.kora;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Row(
        children: [
          InitialsAvatar(name: account.holderName, radius: 34),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.holderName,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '${Brand.current.shortName} · ${account.accountNumber}',
                      style: TextStyle(color: kora.muted),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Copy account number',
                      icon: Icon(
                        Icons.copy_rounded,
                        size: 16,
                        color: kora.muted,
                      ),
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: account.accountNumber),
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Account number copied'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: kora.accent,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    account.tier.label,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: kora.onAccent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
    child: Text(
      title.toUpperCase(),
      style: context.textTheme.labelMedium?.copyWith(
        color: context.kora.muted,
        letterSpacing: 1,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.color,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    leading: Icon(icon, color: color),
    title: Text(title, style: TextStyle(color: color)),
    subtitle: subtitle == null ? null : Text(subtitle!),
    trailing: color == null ? const Icon(Icons.chevron_right_rounded) : null,
    onTap: onTap,
  );
}
