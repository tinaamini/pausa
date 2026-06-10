import 'package:hive/hive.dart';


@HiveType(typeId: 0)
class AppSettings extends HiveObject {
  @HiveField(0)
  String userName;

  @HiveField(1)
  bool isParentMode;

  @HiveField(2)
  int streakDays;

  @HiveField(3)
  String themeMode; // 'dark' | 'light' | 'system'

  // @HiveField(4)
  // String language; // 'fa' | 'en'

  AppSettings({
    this.userName = 'tina',
    this.isParentMode = false,
    this.streakDays = 0,
    this.themeMode = 'system',
    // this.language = 'fa',
  });
}