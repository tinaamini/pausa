import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pausa/data/models/Apps/installed_app.dart';
import 'package:pausa/data/models/app_blocked.dart';

part 'apps_state.dart';

class AppsCubit extends Cubit<AppsState> {
  static const _channel = MethodChannel('com.pausa/apps');

  AppsCubit() : super(const AppsState());

  Future<void> loadApps() async {
    emit(state.copyWith(status: AppsStatus.loading));

    try {
      // خوندن اپ‌های بلاک‌شده از Hive
      final box = Hive.box('blocked_apps');
      final blockedMap = <String, BlockedApp>{};
      for (final key in box.keys) {
        final map = box.get(key);
        if (map != null) {
          final app = BlockedApp.fromMap(map);
          blockedMap[app.packageName] = app;
        }
      }

      final List<dynamic> result =
      await _channel.invokeMethod('getInstalledApps');

      final apps = result.map((e) {
        final map = Map<String, dynamic>.from(e);
        final packageName = map['packageName'] as String;
        final blocked = blockedMap[packageName];

        return InstalledApp(
          packageName: packageName,
          appName: map['appName'] as String,
          icon: map['icon'] as Uint8List?,
          isBlocked: blocked?.isBlocked ?? false,
          dailyLimitMinutes: blocked?.dailyLimitMinutes,
        );
      }).toList();

      emit(state.copyWith(
        apps: apps,
        filteredApps: apps,
        status: AppsStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AppsStatus.error,
        error: e.toString(),
      ));
    }
  }

  void search(String query) {
    final filtered = state.apps.where((app) {
      final matchName = app.appName.toLowerCase().contains(query.toLowerCase());
      final matchBlocked = state.showOnlyBlocked ? app.isBlocked : true;
      return matchName && matchBlocked;
    }).toList();

    emit(state.copyWith(
      searchQuery: query,
      filteredApps: filtered,
    ));
  }

  void toggleShowBlocked(bool value) {
    final filtered = state.apps.where((app) {
      final matchBlocked = value ? app.isBlocked : true;
      final matchSearch = app.appName
          .toLowerCase()
          .contains(state.searchQuery.toLowerCase());
      return matchBlocked && matchSearch;
    }).toList();

    emit(state.copyWith(
      showOnlyBlocked: value,
      filteredApps: filtered,
    ));
  }

  Future<void> toggleBlock(InstalledApp app) async {
    final box = Hive.box('blocked_apps');
    final newBlocked = !app.isBlocked;

    if (newBlocked) {
      final blockedApp = BlockedApp(
        packageName: app.packageName,
        appName: app.appName,
        isBlocked: true,
        dailyLimitMinutes: app.dailyLimitMinutes,
      );
      await box.put(app.packageName, blockedApp.toMap());
    } else {
      await box.delete(app.packageName);
    }

    final updatedApps = state.apps.map((a) {
      if (a.packageName == app.packageName) {
        a.isBlocked = newBlocked;
      }
      return a;
    }).toList();

    final filtered = updatedApps.where((a) {
      final matchBlocked = state.showOnlyBlocked ? a.isBlocked : true;
      final matchSearch = a.appName
          .toLowerCase()
          .contains(state.searchQuery.toLowerCase());
      return matchBlocked && matchSearch;
    }).toList();

    emit(state.copyWith(apps: updatedApps, filteredApps: filtered));
  }

  Future<void> setDailyLimit(InstalledApp app, int? minutes) async {
    final box = Hive.box('blocked_apps');

    final blockedApp = BlockedApp(
      packageName: app.packageName,
      appName: app.appName,
      isBlocked: app.isBlocked,
      dailyLimitMinutes: minutes,
    );
    await box.put(app.packageName, blockedApp.toMap());

    final updatedApps = state.apps.map((a) {
      if (a.packageName == app.packageName) {
        a.dailyLimitMinutes = minutes;
      }
      return a;
    }).toList();

    emit(state.copyWith(apps: updatedApps, filteredApps: updatedApps));
  }
}