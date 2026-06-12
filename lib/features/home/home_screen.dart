import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pausa/core/theme/app_colors.dart';
import 'package:pausa/core/theme/app_size.dart';
import 'package:pausa/core/theme/app_text_style.dart';
import 'package:pausa/features/home/cubit/home_state.dart';
import 'package:pausa/features/home/widgets/focus_session_card.dart';
import 'package:pausa/features/home/widgets/recently_blocked..dart';
import 'package:pausa/features/home/widgets/stats_row.dart';
import 'package:pausa/features/home/widgets/streak_card.dart';
import 'package:pausa/generated/app_localizations.dart';

import 'cubit/home_Cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomeView();
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  String _greeting(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 17) return l10n.goodAfternoon;
    return l10n.goodNight;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                SizedBox(height: AppSize.height * 0.05),

                // welcome
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_greeting(context)}، ${state.userName}! 👋',
                          style: AppTextStyle.greetingTitleStyle(context),
                        ),
                        Text(
                          l10n.welcomeSubtitle,
                          style: AppTextStyle.welcomeSubtitleStyle(context),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => context.pushNamed('/settings'),
                      icon: const Icon(
                        Icons.notifications_on_outlined,
                        size: 34,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FocusSessionCard(
                  hasActive: state.hasFocusSession,
                  remainingSeconds: state.focusRemainingSeconds,
                  onStart: () => context.pushNamed('/focus'),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.today,
                    style: AppTextStyle.FocusSessionCardStyle(
                      context,
                    ).copyWith(color: isDark ? AppColors.darkCard : null),
                  ),
                ),
                const SizedBox(height: 16),

                StatsRow(
                  blockedCount: state.blockedAppsCount,
                  timeSaved: context.read<HomeCubit>().formatTime(
                    state.timeSavedMinutes,
                  ),
                  sessions: state.sessionsCount,
                ),
                const SizedBox(height: 16),
                StreakCard(days: state.streakDays),
                const SizedBox(height: 16),
                RecentlyBlockedSection(
                  apps: state.recentlyBlocked,
                  onViewAll: () => context.pushNamed('/apps'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
