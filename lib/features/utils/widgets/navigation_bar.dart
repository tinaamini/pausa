import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pausa/core/theme/app_colors.dart';
import 'package:pausa/core/theme/app_size.dart';
import 'package:pausa/core/theme/app_text_style.dart';
import 'package:pausa/generated/app_localizations.dart';

class BottomNavigationBarCustom extends StatefulWidget {
  const BottomNavigationBarCustom({super.key});

  @override
  State<BottomNavigationBarCustom> createState() =>
      _BottomNavigationBarCustomState();
}

class _BottomNavigationBarCustomState extends State<BottomNavigationBarCustom> {
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: AppSize.height * 0.075,
      width: double.infinity,
decoration: BoxDecoration(
  color: brightness == Brightness.dark
      ? AppColors.darkCard
      : AppColors.lightCard,
    border: Border(
      top: BorderSide(
        color:AppColors.grayLight,
        width: 1,
      ),
    )
),

      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _container(
              context,
              path: "/more",
              text:l10n.more,
              activeSvg: 'assets/utils/line-3-select.svg',
              inactiveSvg: 'assets/utils/line-3.svg',
            ),
            _container(
              text: l10n.stats,
              context,
              path: "/stats",
              activeSvg: "assets/utils/stats-select.svg",
              inactiveSvg: "assets/utils/stats.svg",
            ),

            _container(
              text: l10n.focus,
              context,
              path: '/focus',
              activeSvg: "assets/utils/focus-select.svg",
              inactiveSvg: "assets/utils/focus.svg",
            ),
            _container(
              text: l10n.apps,
              context,
              path: '/apps',
              activeSvg: "assets/utils/grid-select.svg",
              inactiveSvg: "assets/utils/grid.svg",
            ),
            _container(
              text:l10n.home,
              context,
              path: '/home',
              activeSvg: "assets/utils/home-select.svg",
              inactiveSvg: "assets/utils/home.svg",
            ),
          ],
        ),
      ),
    );
  }

  Widget _container(
    BuildContext context, {
    required String path,
    required String activeSvg,
    required String inactiveSvg,
        required String text,
  }) {
    final String location = GoRouterState.of(context).uri.toString();

    return GestureDetector(
      child: Column(
        children: [
          Container(
            child: SvgPicture.asset(
              location == path ? activeSvg : inactiveSvg,
              width: 28.w,
              height: 28.w,
            ),
          ),
          SizedBox(height: AppSize.height * 0.003,),
          Text(text,style: AppTextStyle.navigationStyle(context).copyWith(color:location == path ? AppColors.primary: AppColors.textMedium),),
        ],
      ),
      onTap: () {
        if (location != path) {
          context.pushNamed(path);
        }
      },
    );
  }
}
