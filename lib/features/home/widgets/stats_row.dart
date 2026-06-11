import 'package:flutter/material.dart';
import 'package:pausa/core/theme/app_size.dart';
import 'package:pausa/core/theme/app_text_style.dart';
import 'package:pausa/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class StatsRow extends StatelessWidget {
  final int blockedCount;
  final String timeSaved;
  final int sessions;

  const StatsRow({
    super.key,
    required this.blockedCount,
    required this.timeSaved,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        _StatBox(value: '$blockedCount', label: l10n.blockApps),
        const SizedBox(width: 12),
        _StatBox(value: timeSaved, label: l10n.timeSaved),
        const SizedBox(width: 12),
        _StatBox(value: '$sessions', label: l10n.sessions),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;

  const _StatBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding:  EdgeInsets.symmetric(vertical: 16,horizontal: AppSize.width *0.04),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyle.welcomeSubtitleStyle(context)),
            const SizedBox(height: 9),

            Text(value, style: AppTextStyle.intStyle(context)),
          ],
        ),
      ),
    );
  }
}
