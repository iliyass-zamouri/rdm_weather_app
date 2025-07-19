import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // static const _color = 0xFFA2291E;
  static const _color = 0xFF131b36;

  static const MaterialColor primarySwatch = MaterialColor(
    _color, // Primary color
    <int, Color>{
      50: Color(_color), // 10%
      100: Color(_color), // 20%
      200: Color(_color), // 30%
      300: Color(_color), // 40%
      400: Color(_color), // 50%
      500: Color(_color), // 60%
      600: Color(_color), // 70%
      700: Color(_color), // 80%
      800: Color(_color), // 90%
      900: Color(_color), // 100%
    },
  );
  static const Color primary = Color(0xFF000000);
  static const Color secondary = Color(_color);
  static const Color premium = Color(0xFF2B2D42);
  static const Color background = Color(0xFFF2F4F5);
  static const Color containerBg = Color(0xFFF1F4F5);
  static const Color error = Color(0xFF9A2E2E);
  static const Color success = Color.fromARGB(255, 44, 117, 47);
  static const Color textPrimary = Color(0xFF323232);
  static const Color textSecondary = Color(0xFF5F6368);
}
