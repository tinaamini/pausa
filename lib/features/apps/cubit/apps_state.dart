part of 'apps_cubit.dart';

enum AppsStatus { initial, loading, loaded, error }

class AppsState {
  final List<InstalledApp> apps;
  final List<InstalledApp> filteredApps;
  final AppsStatus status;
  final String searchQuery;
  final bool showOnlyBlocked;
  final String? error;

  const AppsState({
    this.apps = const [],
    this.filteredApps = const [],
    this.status = AppsStatus.initial,
    this.searchQuery = '',
    this.showOnlyBlocked = false,
    this.error,
  });

  AppsState copyWith({
    List<InstalledApp>? apps,
    List<InstalledApp>? filteredApps,
    AppsStatus? status,
    String? searchQuery,
    bool? showOnlyBlocked,
    String? error,
  }) {
    return AppsState(
      apps: apps ?? this.apps,
      filteredApps: filteredApps ?? this.filteredApps,
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
      showOnlyBlocked: showOnlyBlocked ?? this.showOnlyBlocked,
      error: error ?? this.error,
    );
  }
}