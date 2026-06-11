import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pausa/core/theme/app_text_style.dart';
import 'package:pausa/data/models/app_blocked.dart';
import 'package:pausa/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class RecentlyBlockedSection extends StatelessWidget {
  final List<BlockedApp> apps;
  final VoidCallback onViewAll;

  const RecentlyBlockedSection({
    super.key,
    required this.apps,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n=AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.recentlyBlocked,
        style:AppTextStyle.FocusSessionCardStyle(context).copyWith(color:isDark?AppColors.darkCard:null)),

            // TextButton(
            //   onPressed: onViewAll,
            //   child: Text(
            //     'همه',
            //     style: TextStyle(color: AppColors.primary),
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 8),
        if (apps.isEmpty)
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard.withAlpha(140),              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                l10n.noBlockedApps,
                style: AppTextStyle.FocusSessionCardStyle(context).copyWith(
                  color: isDark
                      ? AppColors.textDark
                      : AppColors.textLight,
                ),
              ),
            ),
          )
        else
          ...apps.map((app) => _AppTile(app: app)),
      ],
    );
  }
}

class _AppTile extends StatelessWidget {
  final BlockedApp app;

  const _AppTile({required this.app});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard.withAlpha(140),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.apps, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.appName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  app.dailyLimitMinutes != null
                      ? '${app.dailyLimitMinutes} دقیقه در روز'
                      : 'کاملاً بلاک',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textDark
                        : AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'بلاک',
              style: TextStyle(
                color: AppColors.error,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}