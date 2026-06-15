import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pausa/core/theme/app_colors.dart';

class AppTextStyle {
  static String _font(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return lang == 'fa' ? 'Shabnam' : 'Inter';
  }




  static TextStyle navigationStyle(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize:14.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.textMedium);
  static TextStyle intStyle(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize:20.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.textLight);


  static greetingTitleStyle(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize:24.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.textLight);
  static FocusSessionCardStyle(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize:20.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.textLight);

  static welcomeSubtitleStyle(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize:14.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.textMedium);
  static timeFocusStyle (BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize:24.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.textLight);
  static usageTitleDialog (BuildContext context) => TextStyle(

      fontFamily: _font(context),
      fontSize:9.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.textLight);
  static usageDescriptionDialog (BuildContext context) => TextStyle(


      fontFamily: _font(context),
      fontSize:8.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.textMedium);





}