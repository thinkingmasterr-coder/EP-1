import 'package:flutter/material.dart';

// ✅ CORRECT NAME: AppColors
// ❌ WRONG NAME: Colors (Do not use this!)
class AppColors {
  // Brand Colors
  static const Color primaryGreen = Color(0xFF00AA4F);
  static const Color darkGreen = Color(0xFF005946);
  static const Color lightGreenBg = Color(0xFFE8F5E9);

  // Backgrounds
  static const Color scaffoldGrey = Color(0xFFF3F4F6);
  static const Color historyBg = Color(0xFFF2F3F5);

  // Status
  static const Color redError = Color(0xFFD32F2F);
  static const Color greenSuccess = Color(0xFF00C05E);

  // Helper to create Material Swatch
  static MaterialColor get primarySwatch => _createMaterialColor(primaryGreen);

  static MaterialColor _createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) strengths.add(0.1 * i);
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}