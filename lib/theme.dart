import 'package:flutter/material.dart';

class AppColors {
  static const navy = Color(0xFF0A1122);
  static const gold = Color(0xFFD4AF37);
}

final ThemeData idmTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.navy,
  colorScheme: ColorScheme.dark(
    primary: AppColors.navy,
    secondary: AppColors.gold,
    background: AppColors.navy,
    surface: Color(0xFF111827),
  ),
  scaffoldBackgroundColor: AppColors.navy,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.navy,
    foregroundColor: AppColors.gold,
    centerTitle: true,
  ),
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: AppColors.gold),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.gold,
      foregroundColor: AppColors.navy,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white10,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
  ),
);
