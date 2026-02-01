// File: lib/amount_experiments.dart
import 'package:flutter/material.dart';

class AmountExperiments {
  // ============================================================
  // 1. TOP HEADER SECTION (The Light Green Area)
  // ============================================================
  static const Color headerBgColor = Color(0xFFFBFEFB); // An even more faded green

  static const TextStyle headerTitle = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headerSubtitle = TextStyle(
    color: Colors.black,
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );

  // Recipient Row in the green area
  static const double receiverAvatarSize = 60.0;
  static const Color avatarBorderColor = Color(0xFF00AA4F); // Green outline

  static const TextStyle receiverInitialsStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  static const TextStyle receiverNameStyle = TextStyle(
    color: Color(0xFF000000),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle receiverNumberStyle = TextStyle(
    color: Color(0xFF000000),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // ============================================================
  // 2. AMOUNT INPUT SECTION (The White Area)
  // ============================================================
  static const String currencySymbol = "Rs.";

  static const TextStyle currencyStyle = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle inputAmountStyle = TextStyle(
    color: Colors.black,
    fontSize: 36,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle enterAmountLabel = TextStyle(
    color: Colors.black87,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  // ============================================================
  // 3. MESSAGE & BUTTON
  // ============================================================
  static const TextStyle addMessageTextStyle = TextStyle(
    color: Colors.black87,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const Color activeBtnColor = Color(0xFF00AA4F);
  static const Color inactiveBtnColor = Color(0xFFE0E0E0);

  static const TextStyle btnTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}
