import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pausa/core/theme/app_colors.dart';
import 'package:pausa/core/theme/app_size.dart';
import 'package:pausa/data/models/Apps/installed_app.dart';
import 'package:pausa/generated/app_localizations.dart';

class AppListTile extends StatelessWidget {
  final InstalledApp app;
  final VoidCallback onToggleBlock;
  final VoidCallback onSetTimeLimit;

  const AppListTile({
    super.key,
    required this.app,
    required this.onToggleBlock,
    required this.onSetTimeLimit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin:  EdgeInsets.only(bottom: AppSize.width * 0.03),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: app.isBlocked
            ? Border.all(color:AppColors.primary.withValues(alpha: 0.4)
        )
            : null,
      ),
      child: Row(
        children: [
          _AppIcon(iconBase64: app.iconBase64),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: onSetTimeLimit,
                  child: Text(
                    app.dailyLimitMinutes != null
                        ? '${app.dailyLimitMinutes}✏️ ${l10n.minutesPerDay}'
                        : l10n.unlimited,
                    style: TextStyle(
                      fontSize: 12,
                      color: app.dailyLimitMinutes != null
                          ? AppColors.primary
                          : isDark
                          ? AppColors.textDark
                          : AppColors.textLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: app.isBlocked,
            onChanged: (_) => onToggleBlock(),
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  final String iconBase64;
  const _AppIcon({required this.iconBase64});

  @override
  Widget build(BuildContext context) {
    if (iconBase64.isEmpty) {
      return _placeholder();
    }
    try {
      final Uint8List bytes = base64Decode(iconBase64);
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(
          bytes,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        ),
      );
    } catch (_) {
      return _placeholder();
    }
  }

  Widget _placeholder() => Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(
      color: AppColors.primary.withOpacity(0.15),
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Icon(Icons.apps, color: AppColors.primary),
  );
}