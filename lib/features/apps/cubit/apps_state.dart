part of 'apps_cubit.dart';

class AppsState {
  final List<InstalledApp> allApps;
  final List<InstalledApp> filteredApps;
  final bool isLoading;
  final String searchQuery;
  final bool showOnlyBlocked;

  const AppsState({
    this.allApps = const [],
    this.filteredApps = const [],
    this.isLoading = true,
    this.searchQuery = '',
    this.showOnlyBlocked = false,
  });

  AppsState copyWith({
    List<InstalledApp>? allApps,
    List<InstalledApp>? filteredApps,
    bool? isLoading,
    String? searchQuery,
    bool? showOnlyBlocked,
  }) {
    return AppsState(
      allApps: allApps ?? this.allApps,
      filteredApps: filteredApps ?? this.filteredApps,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      showOnlyBlocked: showOnlyBlocked ?? this.showOnlyBlocked,
    );
  }
}