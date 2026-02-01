// File: lib/recipient_experiments.dart
import 'package:flutter/material.dart';

class RecipientExperiments {
  // ============================================================
  // 1. TOP INSTRUCTION ("Enter Mobile Number...")
  // ============================================================
  static const TextStyle instructionText = TextStyle(
    color: Colors.black87,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const EdgeInsets instructionPadding = EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 8
  );

  // ============================================================
  // 2. SEARCH BAR CONTAINER
  // ============================================================
  static const double searchBarHeight = 50.0; // The total height
  static const double greenLineWidth = 4.0;   // Thickness of the green strip
  static const Color searchBarBgColor = Colors.white; // CHANGED
  static const double searchBarRadius = 10.0;

  // ============================================================
  // 3. SEARCH INPUT TEXT
  // ============================================================
  static const TextStyle inputTextStyle = TextStyle(
    fontSize: 13,
    color: Colors.black,
    fontWeight: FontWeight.w600, // CHANGED to semi-bold
  );

  static const TextStyle hintTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 12,
  );

  // Use this to nudge text UP or DOWN if it looks misaligned
  static const EdgeInsets inputContentPadding = EdgeInsets.only(
      left: 4,
      bottom: 2  // <--- Tweak this number to move text vertically
  );

  // ============================================================
  // 4. SECTION HEADER ("Your easypaisa Contacts")
  // ============================================================
  // The background color of the bar
  static const Color headerBgColor = Color(0xFFFAFAFA);

  // Controls the "thickness" of the bar.
  // Smaller vertical padding = thinner bar (closer to text height).
  static const EdgeInsets headerPadding = EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 4  // <--- REDUCED this to make the bar thinner
  );

  static const TextStyle headerText = TextStyle(
    color: Colors.black,
    fontSize: 13,
    fontWeight: FontWeight.w900, // Semi-bold
  );

  // ============================================================
  // 5. CONTACT LIST ITEMS
  // ============================================================
  static const TextStyle contactName = TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.w600, // CHANGED
  );

  static const TextStyle contactNumber = TextStyle(
    color: Colors.grey, // darker grey
    fontSize: 13,
  );

  static const double avatarSize = 38.0; // Size of the circle - CHANGED
}
