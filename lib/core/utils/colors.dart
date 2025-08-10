import 'package:flutter/material.dart';

/// App color palette
class AppColors {
  AppColors._();

  static const _color = 0xFF131b36;

  static const MaterialColor primarySwatch = MaterialColor(
    _color,
    <int, Color>{
      50: Color(_color),
      100: Color(_color),
      200: Color(_color),
      300: Color(_color),
      400: Color(_color),
      500: Color(_color),
      600: Color(_color),
      700: Color(_color),
      800: Color(_color),
      900: Color(_color),
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
