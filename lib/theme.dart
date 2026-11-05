import 'package:flutter/material.dart';

const Color kBg = Color(0xFF0F0F0F);
const Color kCard = Color(0xFF1A1A1A);
const Color kPrimary = Color(0xFFFF6B00); // برتقالي
const Color kSecondary = Color(0xFF00A8FF); // أزرق
const Color kGray = Color(0xFF888888);
const Color kSuccess = Color(0xFF2ECC71);

const TextStyle kTitle = TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
const TextStyle kSub = TextStyle(fontSize: 13, color: kGray);

ThemeData buildTheme() {
  final ColorScheme scheme = ColorScheme.fromSeed(
    seedColor: kPrimary,
    brightness: Brightness.dark,
  ).copyWith(
    primary: kPrimary,
    onPrimary: Colors.white,
    secondary: kSecondary,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: kBg,
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color(0xFF151515),
      indicatorColor: Color(0x33FF6B00),
    ),
  );
}
