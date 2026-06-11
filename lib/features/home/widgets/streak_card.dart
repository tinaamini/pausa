import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pausa/core/theme/app_size.dart';
import 'package:pausa/core/theme/app_text_style.dart';
import 'package:pausa/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class StreakCard extends StatelessWidget {
  final int days;

  const StreakCard({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
final l10n =AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard.withAlpha(140),
        borderRadius: BorderRadius.circular(20),

      ),
      child: Row(
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.currentStreak,
                style: AppTextStyle.FocusSessionCardStyle(context).copyWith(
                  color: isDark
                      ? AppColors.textDark
                      : AppColors.textLight,
                ),
              ),
              SizedBox(height:AppSize.height * 0.008),

              Text(
                '${days}${l10n.days}',
               style:  AppTextStyle.FocusSessionCardStyle(context).copyWith(
                  color: isDark
                      ? AppColors.textDark
                      : AppColors.textLight,
              ),),
              SizedBox(height:AppSize.height * 0.01),

              Text(
               l10n.keepItUp,
                style: AppTextStyle.welcomeSubtitleStyle(context)
              ),

            ],
          ),
          const Spacer(),
          const Text('🔥', style: TextStyle(fontSize: 60)),
        ],
      ),
    );
  }
}