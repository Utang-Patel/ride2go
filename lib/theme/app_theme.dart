import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2D68FF);
  static const secondary = Color(0xFF1C1C1E);
  static const accent = Color(0xFF4CAF50);
  static const accentOrange = Color(0xFFFF9800);
  static const accentBlue = Color(0xFF2196F3);
  static const bg = Color(0xFFF9F9FB);
  static const card = Colors.white;
  static const textDark = Color(0xFF1C1C1E);
  static const textGrey = Color(0xFF8E8E93);
  static const divider = Color(0xFFE5E5EA);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      );
}
