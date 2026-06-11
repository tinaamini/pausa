import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pausa/core/theme/app_size.dart';
import 'package:pausa/core/theme/app_text_style.dart';
import 'package:pausa/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class FocusSessionCard extends StatelessWidget {
  final bool hasActive;
  final int remainingSeconds;
  final VoidCallback onStart;

  const FocusSessionCard({
    super.key,
    required this.hasActive,
    required this.remainingSeconds,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
final l10n=AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
      color:isDark?AppColors.darkCard  : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.focusSession,
                 style: AppTextStyle.FocusSessionCardStyle(context).copyWith(color:isDark?AppColors.lightCard:null),
                ),
                const SizedBox(height: 4),
                Text(l10n.deepWork,style: AppTextStyle.welcomeSubtitleStyle(context),),
                Text(
                  hasActive
                      ? _formatSeconds(remainingSeconds)
                      : '00:00',
                  style: AppTextStyle.timeFocusStyle(context).copyWith(color:isDark?AppColors.lightCard:null)
                ),
                SizedBox(height: AppSize.height * 0.02,),
                SizedBox(width: AppSize.width * 0.35,height: AppSize.height * 0.05,
                  child: ElevatedButton(
                    onPressed: onStart,
                    style: ElevatedButton.styleFrom(

                      backgroundColor: isDark ? AppColors.primaryDark:AppColors.primaryLight,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(hasActive ? l10n.continueButton : l10n.start ,style: AppTextStyle.welcomeSubtitleStyle(context).copyWith(color: isDark ?AppColors.lightCard:AppColors.primaryDark),),
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: AppSize.width * 0.5,height: AppSize.height * 0.15,
           child: SvgPicture.asset("assets/home/Untitled-1.svg"),
          )

        ],
      ),
    );
  }

  String _formatSeconds(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}