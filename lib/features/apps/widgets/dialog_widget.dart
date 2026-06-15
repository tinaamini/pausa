import 'package:flutter/material.dart';
import 'package:pausa/core/theme/app_colors.dart';
import 'package:pausa/core/theme/app_text_style.dart';
import 'package:pausa/features/apps/cubit/apps_cubit.dart';
import 'package:pausa/generated/app_localizations.dart';
import 'PermissionBox.dart';

class DialogWidget extends StatelessWidget {
  final AppsCubit cubit;

  const DialogWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor:
      isDark ? AppColors.backGroundDark : AppColors.backGroundLight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 480,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/utils/usage.png",
                width: screenWidth * 0.35,
              ),
              Text(
                l10n.trackAppsUsage,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.trackAppsUsageDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              PermissionBox(
                itemIcons: const [
                  Icons.shield_outlined,
                  Icons.bar_chart_outlined,
                  Icons.timer_outlined,
                  Icons.calendar_month,
                ],
                items: [
                  l10n.permissionFeature1Title,
                  l10n.permissionFeature2Title,
                  l10n.permissionFeature3Title,
                  l10n.permissionFeature4Title,
                ],
                items2: [
                  l10n.permissionFeature1Desc,
                  l10n.permissionFeature2Desc,
                  l10n.permissionFeature3Desc,
                  l10n.permissionFeature4Desc,
                ],
              ),
              const SizedBox(height: 16),
              _PermissionBoxSee(
                title: l10n.permissionCanSee,
                icon: Icons.remove_red_eye_sharp,
                items: [
                  l10n.permissionCanSeeItem1,
                  l10n.permissionCanSeeItem2,
                  l10n.permissionCanSeeItem3,
                  l10n.permissionCanSeeItem4,
                ],
                itemColor: AppColors.success,
                isAllowed: true,
              ),
              const SizedBox(height: 8),
              _PermissionBoxSee(
                title: l10n.permissionCannotSee,
                icon: Icons.lock_open_outlined,
                items: [
                  l10n.permissionCannotSeeItem1,
                  l10n.permissionCannotSeeItem2,
                  l10n.permissionCannotSeeItem3,
                  l10n.permissionCannotSeeItem4,
                ],
                itemColor: AppColors.accent,
                isAllowed: false,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    cubit.requestOverlayPermission();
                  },
                  icon: const Icon(Icons.lock, size: 18),
                  label: Text(
                    l10n.permissionGrantButton,
                    style: AppTextStyle.welcomeSubtitleStyle(context)
                        .copyWith(color: AppColors.textDark),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.permissionNotNow,
                  style: AppTextStyle.welcomeSubtitleStyle(context)
                      .copyWith(color: AppColors.primary),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, size: 23, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          l10n.permissionPrivacyNote,
                          style: AppTextStyle.usageTitleDialog(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionBoxSee extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> items;
  final Color itemColor;
  final bool isAllowed;

  const _PermissionBoxSee({
    required this.title,
    required this.icon,
    required this.items,
    required this.itemColor,
    required this.isAllowed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isAllowed
            ? AppColors.success.withAlpha(15)
            : AppColors.accent.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: itemColor.withAlpha(50)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // آیکون با سایز ثابت
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: itemColor.withAlpha(20),
            ),
            child: Icon(icon, size: 24, color: itemColor),
          ),
          const SizedBox(width: 12),
          // محتوا — Expanded برای پر کردن فضای باقی‌مانده
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.welcomeSubtitleStyle(context)
                      .copyWith(color: itemColor),
                ),
                const SizedBox(height: 8),
                // Wrap به‌جای GridView — آیتم‌ها خودشان می‌چینند
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: items
                      .map(
                        (item) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isAllowed ? Icons.circle : Icons.close,
                          size: 11,
                          color: itemColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item,
                          style:
                          AppTextStyle.usageDescriptionDialog(context),
                        ),
                      ],
                    ),
                  )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}