import 'package:flutter/material.dart';
import 'package:new_project/Core/theme/colors.dart';
import 'package:new_project/Core/theme/font_weidget_helper.dart';

class AppTextStyles {
  static const String defaultFontFamily = 'Cairo';

  static TextStyle heading = const TextStyle(
    fontSize: 32,
    fontWeight: FontWeightHelper.bold,
    color: AppColors.primaryColor,
    fontFamily: defaultFontFamily,
  );

  static TextStyle textbody = const TextStyle(
    fontSize: 40,
    color: AppColors.textColor2,
    fontFamily: defaultFontFamily,
  );

  static TextStyle button = const TextStyle(
    fontSize: 32,
    color: AppColors.textColor1,
    fontWeight: FontWeightHelper.bold,
    fontFamily: defaultFontFamily,
  );

  static TextStyle error = const TextStyle(
    fontSize: 14,
    color: AppColors.errorColor,
    fontFamily: defaultFontFamily,
  );
  static TextStyle textNav = const TextStyle(
    fontSize: 18,
    color: AppColors.textColor3,
    fontFamily: defaultFontFamily,
  );
  static TextStyle navtext = const TextStyle(
    fontSize: 14,
    color: AppColors.navColor,
    fontFamily: defaultFontFamily,
  );

  static void setFontFamily(String fontFamily) {
    heading = heading.copyWith(fontFamily: fontFamily);
    textbody = textbody.copyWith(fontFamily: fontFamily);
    button = button.copyWith(fontFamily: fontFamily);
    error = error.copyWith(fontFamily: fontFamily);
  }
}
