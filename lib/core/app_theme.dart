import 'package:flutter/material.dart';

abstract final class AppColors {
  static const ink = Color(0xFF101D26);
  static const lime = Color(0xFFF7A928);
  static const paper = Color(0xFFF3F5F3);
  static const muted = Color(0xFF64737A);
  static const line = Color(0xFFDFE6E7);
  static const orange = Color(0xFF1D8A63);
  static const blue = Color(0xFF5E8CFF);
}

abstract final class AppTheme {
  static ThemeData get data => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.paper,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.lime),
    fontFamily: 'Arial',
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
      ),
    ),
  );
}
