import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // ================= LIGHT THEME =================
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryTeal,
    scaffoldBackgroundColor: AppColors.offWhite,
    cardColor: Colors.white,
    dividerColor: Colors.grey.shade300,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryTeal,
      secondary: AppColors.warmAmber,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    iconTheme: const IconThemeData(color: Colors.black54),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.offWhite,
      foregroundColor: Colors.black87,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.offWhite,
      selectedItemColor: AppColors.primaryTeal,
      unselectedItemColor: Colors.grey.shade600,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryTeal,
    ),
  );

  // ================= DARK THEME =================
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryTealDark,
    scaffoldBackgroundColor: AppColors.offWhiteDark,
    cardColor: AppColors.lightGreyDark,
    dividerColor: Colors.grey.shade700,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryTealDark,
      secondary: AppColors.warmAmberDark,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    iconTheme: const IconThemeData(color: Colors.white70),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.offWhiteDark,
      foregroundColor: Colors.white70,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightGreyDark,
      selectedItemColor: AppColors.primaryTealDark,
      unselectedItemColor: Colors.grey.shade400,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryTealDark,
    ),
  );
}
