import 'package:hive/hive.dart';

class AppSettings {
  String userName;
  bool isParentMode;
  int streakDays;
  String themeMode;
  String language;

  AppSettings({
    this.userName = 'کاربر',
    this.isParentMode = false,
    this.streakDays = 0,
    this.themeMode = 'system',
    this.language = 'fa',
  });

  Map<String, dynamic> toMap() => {
    'userName': userName,
    'isParentMode': isParentMode,
    'streakDays': streakDays,
    'themeMode': themeMode,
    'language': language,
  };

  factory AppSettings.fromMap(Map map) => AppSettings(
    userName: map['userName'] ?? 'کاربر',
    isParentMode: map['isParentMode'] ?? false,
    streakDays: map['streakDays'] ?? 0,
    themeMode: map['themeMode'] ?? 'system',
    language: map['language'] ?? 'fa',
  );
}