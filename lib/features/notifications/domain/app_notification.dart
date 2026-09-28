import 'package:flutter/material.dart';

@immutable
class AppNotification {
  const AppNotification({
    required this.id,
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    this.route,
  });

  final String id;
  final IconData icon;
  final String title;
  final String body;
  final DateTime time;

  /// Where tapping it goes, if anywhere.
  final String? route;
}
