import 'package:hive/hive.dart';

// part 'blocked_app.g.dart';

@HiveType(typeId: 1)
class BlockedApp extends HiveObject {
  @HiveField(0)
  String packageName;

  @HiveField(1)
  String appName;

  @HiveField(2)
  bool isBlocked;

  @HiveField(3)
  int? dailyLimitMinutes;

  @HiveField(4)
  int usedTodayMinutes;

  BlockedApp({
    required this.packageName,
    required this.appName,
    this.isBlocked = false,
    this.dailyLimitMinutes,
    this.usedTodayMinutes = 0,
  });
}