
class HomeState {
  final String userName;
  final int streakDays;
  final int blockedAppsCount;
  final int timeSavedMinutes;
  final int sessionsCount;
  // final List<BlockedApp> recentlyBlocked;
  final bool hasFocusSession;
  final int focusRemainingSeconds;
  final bool isLoading;

  const HomeState({
    this.userName = '',
    this.streakDays = 0,
    this.blockedAppsCount = 0,
    this.timeSavedMinutes = 0,
    this.sessionsCount = 0,
    // this.recentlyBlocked = const [],
    this.hasFocusSession = false,
    this.focusRemainingSeconds = 0,
    this.isLoading = true,
  });

  HomeState copyWith({
    String? userName,
    int? streakDays,
    int? blockedAppsCount,
    int? timeSavedMinutes,
    int? sessionsCount,
    // List<BlockedApp>? recentlyBlocked,
    bool? hasFocusSession,
    int? focusRemainingSeconds,
    bool? isLoading,
  }) {
    return HomeState(
      userName: userName ?? this.userName,
      streakDays: streakDays ?? this.streakDays,
      blockedAppsCount: blockedAppsCount ?? this.blockedAppsCount,
      timeSavedMinutes: timeSavedMinutes ?? this.timeSavedMinutes,
      sessionsCount: sessionsCount ?? this.sessionsCount,
      // recentlyBlocked: recentlyBlocked ?? this.recentlyBlocked,
      hasFocusSession: hasFocusSession ?? this.hasFocusSession,
      focusRemainingSeconds: focusRemainingSeconds ?? this.focusRemainingSeconds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}