import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pausa/data/models/app_blocked.dart';
import 'package:pausa/data/models/app_setting.dart';

import 'home_state.dart';




class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  Future<void> loadData() async {
    try {
      emit(state.copyWith(isLoading: true));

      final settingsBox = Hive.box('settings');
      final appsBox = Hive.box('blocked_apps');

      final settingsMap = settingsBox.get('main');
      final settings = settingsMap != null
          ? AppSettings.fromMap(settingsMap)
          : AppSettings();

      final allApps = appsBox.values
          .map((e) => BlockedApp.fromMap(e))
          .toList();

      final blockedApps = allApps.where((a) => a.isBlocked).toList();

      emit(state.copyWith(
        userName: settings.userName,
        streakDays: settings.streakDays,
        blockedAppsCount: blockedApps.length,
        timeSavedMinutes: blockedApps.fold(0, (sum, a) => sum! + (a.dailyLimitMinutes ?? 0)),
        sessionsCount: 3,
        recentlyBlocked: blockedApps.take(3).toList(),
        isLoading: false,
      ));

    } catch (e, stack) {
      debugPrint('❌ HomeCubit error: $e');
      debugPrint(stack.toString());
      emit(state.copyWith(isLoading: false));
    }
  }  String formatTime(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}