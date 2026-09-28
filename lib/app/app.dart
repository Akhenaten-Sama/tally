import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import 'app_lock_guard.dart';
import 'router.dart';
import '../core/brand/brand.dart';

class TallyApp extends ConsumerWidget {
  const TallyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: Brand.current.shortName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: ref.watch(routerProvider),
      builder: (_, child) => AppLockGuard(child: child!),
    );
  }
}
