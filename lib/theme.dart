import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static const Color brandBlue = Color(0xFF0094FA);
  static const Color brandDarkBlue = Color(0xFF008CEC);

  static const Color systemRed = Color(0xFFFF3B30);
  static const Color systemDarkRed = Color(0xFFFF453A);
  static const Color systemGreen = Color(0xFF34C759);
  static const Color systemDarkGreen = Color(0xFF32D74B);
  static const Color systemOrange = Color(0xFFFF9500);
  static const Color systemDarkOrange = Color(0xFFFF9F0A);

  static const Color backgroundPrimary = AppColors.white;
  static const Color backgroundSecondary = Color(0xFFE7EDF3);
  static const Color backgroundDarkPrimary = Color(0xFF0E0E0E);
  static const Color backgroundDarkSecondary = Color(0xFF2C2C2E);

  static const Color typographyPrimary = Color(0xF2000000);
  static const Color typographySecondary = Color(0xB3000000);
  static const Color typographyTertiary = Color(0x66000000);
  static const Color typographyDarkPrimary = Color(0xF2FFFFFF);
  static const Color typographyDarkSecondary = Color(0xB3FFFFFF);
  static const Color typographyDarkTertiary = Color(0x66FFFFFF);

  static const Color grey3 = Color(0xFF636366);
  static const Color grey5 = Color(0xFFD1D1D6);
  static const Color grey6 = Color(0xFFE5E5EA);
  static const Color grey7 = Color(0xFF8B8E92);
  static const Color darkGrey3 = Color(0xFFAEAEB2);
  static const Color darkGrey5 = Color(0xFF3A3A3C);
  static const Color darkGrey6 = Color(0xFF242426);
  static const Color darkGrey7 = Color(0xFF808082);

  static const Color border = Color(0x0A000000);
  static const Color borderDark = Color(0x0AFFFFFF);

  static const Color divider = Color(0xFFE9E9E9);
  static const Color dividerDark = Color(0xFF38383A);

  static const Color shadow = Color(0x33000000);
}

ThemeData themeLight = ThemeData(
  fontFamily: 'Inter',
  appBarTheme: AppBarTheme(
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    backgroundColor: AppColors.backgroundPrimary,
    iconTheme: IconThemeData(color: AppColors.typographyPrimary),
    titleTextStyle: TextStyle(
      color: AppColors.typographyPrimary,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      fontSize: 17,
    ),
    elevation: 0,
  ),
  scaffoldBackgroundColor: AppColors.backgroundPrimary,
  dividerTheme: DividerThemeData(color: AppColors.divider),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    unselectedItemColor: AppColors.grey3,
    selectedItemColor: AppColors.brandBlue,
  ),
);

ThemeData themeDark = ThemeData(
  fontFamily: 'Inter',
  appBarTheme: AppBarTheme(
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    backgroundColor: AppColors.backgroundDarkPrimary,
    iconTheme: IconThemeData(color: AppColors.typographyDarkPrimary),
    titleTextStyle: TextStyle(
      color: AppColors.typographyDarkPrimary,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      fontSize: 17,
    ),
    elevation: 0,
  ),
  scaffoldBackgroundColor: AppColors.backgroundDarkPrimary,
  dividerTheme: DividerThemeData(color: AppColors.dividerDark),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.white,
    unselectedItemColor: AppColors.darkGrey3,
    selectedItemColor: AppColors.brandDarkBlue,
  ),
);
