import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pausa/data/models/Apps/installed_app.dart';
import '../../../data/models/app_blocked.dart';

part 'apps_state.dart';

class AppsCubit extends Cubit<AppsState> {
  static const _channel = MethodChannel('app_blocker_channel');

  AppsCubit() : super(const AppsState());

  Future<void> loadApps() async {
    try {
      emit(state.copyWith(isLoading: true));

      final List result = await _channel.invokeMethod('getInstalledApps');
      final appsBox = Hive.box('blocked_apps');

      final apps = result.map((e) {
        final app = InstalledApp.fromMap(e);
        final saved = appsBox.get(app.packageName);
        if (saved != null) {
          final blockedApp = BlockedApp.fromMap(saved);
          app.isBlocked = blockedApp.isBlocked;
          app.dailyLimitMinutes = blockedApp.dailyLimitMinutes;
        }
        return app;
      }).toList();

      apps.sort((a, b) {
        if (a.isBlocked && !b.isBlocked) return -1;
        if (!a.isBlocked && b.isBlocked) return 1;
        return a.name.compareTo(b.name);
      });

      emit(state.copyWith(
        allApps: apps,
        filteredApps: apps,
        isLoading: false,
      ));
      await _syncBlockedAppsToNative();
    } catch (e) {
      debugPrint('❌ AppsCubit error: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  void search(String query) {
    final filtered = state.allApps.where((app) {
      final matchName = app.name.toLowerCase().contains(query.toLowerCase());
      final matchBlocked = !state.showOnlyBlocked || app.isBlocked;
      return matchName && matchBlocked;
    }).toList();

    emit(state.copyWith(searchQuery: query, filteredApps: filtered));
  }

  void toggleShowBlocked(bool value) {
    final filtered = state.allApps.where((app) {
      final matchBlocked = !value || app.isBlocked;
      final matchSearch = app.name
          .toLowerCase()
          .contains(state.searchQuery.toLowerCase());
      return matchBlocked && matchSearch;
    }).toList();

    emit(state.copyWith(showOnlyBlocked: value, filteredApps: filtered));
  }

  Future<void> toggleBlock(InstalledApp app) async {
    final appsBox = Hive.box('blocked_apps');
    app.isBlocked = !app.isBlocked;

    final blockedApp = BlockedApp(
      packageName: app.packageName,
      appName: app.name,
      isBlocked: app.isBlocked,
      dailyLimitMinutes: app.dailyLimitMinutes,
    );
    await appsBox.put(app.packageName, blockedApp.toMap());

    await _syncBlockedAppsToNative();

    emit(state.copyWith(
      allApps: List<InstalledApp>.from(state.allApps),
      filteredApps: List<InstalledApp>.from(state.filteredApps),
    ));
  }

  Future<void> setTimeLimit(InstalledApp app, int? minutes) async {
    final appsBox = Hive.box('blocked_apps');
    app.dailyLimitMinutes = minutes;

    final blockedApp = BlockedApp(
      packageName: app.packageName,
      appName: app.name,
      isBlocked: app.isBlocked,
      dailyLimitMinutes: minutes,
    );
    await appsBox.put(app.packageName, blockedApp.toMap());

    emit(state.copyWith(
      allApps: List<InstalledApp>.from(state.allApps),
      filteredApps: List<InstalledApp>.from(state.filteredApps),
    ));
  }

  Future<void> _syncBlockedAppsToNative() async {
    final appsBox = Hive.box('blocked_apps');
    final blockedPackages = <String>[];

    for (var key in appsBox.keys) {
      final data = appsBox.get(key);
      if (data != null) {
        final blockedApp = BlockedApp.fromMap(data);
        if (blockedApp.isBlocked) {
          blockedPackages.add(blockedApp.packageName);
        }
      }
    }

    try {
      await _channel.invokeMethod('updateBlockedApps', {'apps': blockedPackages});
    } catch (e) {
      debugPrint('❌ sync error: $e');
    }
  }
}