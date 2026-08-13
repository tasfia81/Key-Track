import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B);    // Slate 800
  static const Color darkCard = Color(0xFF334155);       // Slate 700
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF1F5F9);       // Slate 100
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate 900
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate 500

  // Accent Colors
  static const Color primary = Color(0xFF6366F1); // Indigo 500

  // Status Colors (Soft and premium, not harsh red/green)
  static const Color statusAvailableBg = Color(0xFFDCFCE7); // Soft green
  static const Color statusAvailableText = Color(0xFF15803D);

  static const Color statusTakenBg = Color(0xFFFEF9C3); // Soft amber
  static const Color statusTakenText = Color(0xFFA16207);

  static const Color statusOverdueBg = Color(0xFFFEE2E2); // Soft red
  static const Color statusOverdueText = Color(0xFFB91C1C);

  // Status Colors Dark Mode
  static const Color statusAvailableBgDark = Color(0xFF064E3B);
  static const Color statusAvailableTextDark = Color(0xFF6EE7B7);

  static const Color statusTakenBgDark = Color(0xFF78350F);
  static const Color statusTakenTextDark = Color(0xFFFDE047);

  static const Color statusOverdueBgDark = Color(0xFF7F1D1D);
  static const Color statusOverdueTextDark = Color(0xFFFCA5A5);
}
