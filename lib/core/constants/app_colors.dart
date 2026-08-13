import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Premium Dark Corporate Theme Colors
  static const Color background = Color(0xFF0B2118); // Deep dark green
  static const Color secondaryBackground = Color(0xFF080B09); // Near-black
  static const Color card = Color(0xFF080B09); // Black background for containers
  static const Color primary = Color(0xFFD4AF37); // Elegant gold
  static const Color lightGold = Color(0xFFF1D77A);
  static const Color textPrimary = Color(0xFFF5F5F0); // Warm white
  static const Color textSecondary = Color(0xFFA7B3AA); // Muted gray-green
  static const Color border = Color(0xFF6F5A20); // Subtle dark gold

  // Status Colors (Harmonized with the dark green/gold environment)
  static const Color statusAvailableBg = Color(0x1F10B981); // Emerald green with opacity
  static const Color statusAvailableText = Color(0xFF34D399);

  static const Color statusTakenBg = Color(0x1FD4AF37); // Gold with opacity
  static const Color statusTakenText = Color(0xFFF1D77A);

  static const Color statusOverdueBg = Color(0x1FEF4444); // Coral red with opacity
  static const Color statusOverdueText = Color(0xFFF87171);
}
