// apps_state.dart — اضافه کردن pendingBlockApp

part of 'apps_cubit.dart';

class AppsState {
  final List<InstalledApp> allApps;
  final List<InstalledApp> filteredApps;
  final bool isLoading;
  final bool showOnlyBlocked;
  final String searchQuery;
  final int permissionDeniedCount;
  final InstalledApp? pendingBlockApp;


  const AppsState({
    this.allApps = const [],
    this.filteredApps = const [],
    this.isLoading = false,
    this.showOnlyBlocked = false,
    this.searchQuery = '',
    this.permissionDeniedCount = 0,
    this.pendingBlockApp,
  });

  AppsState copyWith({
    List<InstalledApp>? allApps,
    List<InstalledApp>? filteredApps,
    bool? isLoading,
    bool? showOnlyBlocked,
    String? searchQuery,
    int? permissionDeniedCount,
    InstalledApp? pendingBlockApp,
    bool clearPendingApp = false,
  }) {
    return AppsState(
      allApps: allApps ?? this.allApps,
      filteredApps: filteredApps ?? this.filteredApps,
      isLoading: isLoading ?? this.isLoading,
      showOnlyBlocked: showOnlyBlocked ?? this.showOnlyBlocked,
      searchQuery: searchQuery ?? this.searchQuery,
      permissionDeniedCount: permissionDeniedCount ?? this.permissionDeniedCount,
      pendingBlockApp: clearPendingApp ? null : (pendingBlockApp ?? this.pendingBlockApp),
    );
  }
}