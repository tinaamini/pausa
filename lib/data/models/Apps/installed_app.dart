class InstalledApp {
  final String name;
  final String packageName;
  final String iconBase64;
  bool isBlocked;
  int? dailyLimitMinutes;

  InstalledApp({
    required this.name,
    required this.packageName,
    required this.iconBase64,
    this.isBlocked = false,
    this.dailyLimitMinutes,
  });

  factory InstalledApp.fromMap(Map map) => InstalledApp(
    name: map['name'] ?? '',
    packageName: map['package'] ?? '',
    iconBase64: map['icon'] ?? '',
  );
}