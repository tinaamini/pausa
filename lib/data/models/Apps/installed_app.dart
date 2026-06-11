import 'dart:typed_data';

class InstalledApp {
  final String packageName;
  final String appName;
  final Uint8List? icon;
  bool isBlocked;
  int? dailyLimitMinutes;

  InstalledApp({
    required this.packageName,
    required this.appName,
    this.icon,
    this.isBlocked = false,
    this.dailyLimitMinutes,
  });
}