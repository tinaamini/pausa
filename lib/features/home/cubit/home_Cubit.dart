import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pausa/data/models/app_blocked.dart';
import 'package:pausa/data/models/app_setting.dart';

import 'home_state.dart';




class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true));

    final settingsBox = Hive.box<AppSettings>('settings');
    final appsBox = Hive.box<BlockedApp>('blocked_apps');

    final settings = settingsBox.get('main') ??
        AppSettings(userName: 'کاربر');

    final allApps = appsBox.values.toList();
    final blockedApps = allApps.where((a) => a.isBlocked).toList();
    final recentlyBlocked = blockedApps.take(3).toList();

    // محاسبه زمان ذخیره‌شده امروز
    final timeSaved = blockedApps.fold<int>(
      0,
          (sum, app) => sum + (app.dailyLimitMinutes ?? 0),
    );

    emit(state.copyWith(
      userName: settings.userName,
      streakDays: settings.streakDays,
      blockedAppsCount: blockedApps.length,
      timeSavedMinutes: timeSaved,
      sessionsCount: 3, // بعداً از Hive میخونیم
      // recentlyBlocked: recentlyBlocked,
      isLoading: false,
    ));
  }

  String formatTime(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}