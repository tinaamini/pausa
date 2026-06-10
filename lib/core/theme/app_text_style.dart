import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pausa/core/theme/app_colors.dart';

class AppTextStyle {
  static String _font(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return lang == 'fa' ? 'Shabnam' : 'Inter';
  }



  static TextStyle navigation(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize:12.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.navigation);





}