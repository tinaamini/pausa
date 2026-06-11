class BlockedApp {
  String packageName;
  String appName;
  bool isBlocked;
  int? dailyLimitMinutes;
  int usedTodayMinutes;

  BlockedApp({
    required this.packageName,
    required this.appName,
    this.isBlocked = false,
    this.dailyLimitMinutes,
    this.usedTodayMinutes = 0,
  });

  Map<String, dynamic> toMap() => {
    'packageName': packageName,
    'appName': appName,
    'isBlocked': isBlocked,
    'dailyLimitMinutes': dailyLimitMinutes,
    'usedTodayMinutes': usedTodayMinutes,
  };

  factory BlockedApp.fromMap(Map map) => BlockedApp(
    packageName: map['packageName'],
    appName: map['appName'],
    isBlocked: map['isBlocked'] ?? false,
    dailyLimitMinutes: map['dailyLimitMinutes'],
    usedTodayMinutes: map['usedTodayMinutes'] ?? 0,
  );
}