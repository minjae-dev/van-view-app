import 'package:flutter/material.dart';

class AppColors {
  const AppColors();

  static const Color primary = Color(0xFF1976D2);
  static const Color secondary = Color(0xFF5DADE2);
  static const Color background = Color(0xFFF5F5F5);
  static const Color onPrimary = Colors.white;
  static const Color onBackground = Colors.black;
}

class AppPaddings {
  const AppPaddings();

  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
}

class AppTextStyles {
  const AppTextStyles();

  static const TextStyle headMain = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle body = TextStyle(fontSize: 16);
  static const TextStyle caption = TextStyle(fontSize: 12, color: Colors.grey);

  static TextStyle? get button => TextStyle(fontSize: 12, color: Colors.black);
}

class AppIconSizes {
  const AppIconSizes();
  static const double small = 40.0;
  static const double medium = 60.0;
  static const double large = 80.0;
  static const double extraLarge = 100.0;
}
