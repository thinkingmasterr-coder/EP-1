// File: lib/experiment_styles.dart
import 'package:flutter/material.dart';

class ExperimentStyles {
  // ============================================================
  // 1. APP BAR TITLE ("Send Money")
  // ============================================================
  static const TextStyle appBarTitle = TextStyle(
    color: Colors.black,
    fontSize: 16,                 // Try: 14, 15, 17, 18
    fontWeight: FontWeight.w700,  // Try: w400, w500, w600, w800, w900
  );

  // ============================================================
  // 2. TAB HEADERS ("Send Money" vs "History")
  // ============================================================
  static const TextStyle tabSelected = TextStyle(
    color: Color(0xFF00AA4F),
    fontSize: 14,
    fontWeight: FontWeight.w500, // Try making this lighter (w600)
  );

  static const TextStyle tabUnselected = TextStyle(
    color: Colors.grey,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // ============================================================
  // 3. TOGGLE SWITCH ("Mobile No." vs "Digital Account")
  // ============================================================
  static const TextStyle toggleSelected = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w700, // Try: w600 for a softer look
  );

  static const TextStyle toggleUnselected = TextStyle(
    color: Colors.grey, // Note: Colors.grey[600] is roughly Color(0xFF757575)
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  // ============================================================
  // 4. INPUT LABEL ("Enter Receiver's Mobile Number")
  // ============================================================
  static const TextStyle inputLabel = TextStyle(
    color: Colors.black87,
    fontSize: 13,                 // Try: 12, 14
    fontWeight: FontWeight.w500,  // Try: w500, w600
  );

  // ============================================================
  // 5. SEARCH BOX TEXT
  // ============================================================
  // The text you actually type (e.g., "03...")
  static const TextStyle inputText = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400, // Usually normal weight
  );

  // The hint text ("Enter Receiver's Number...")
  static const TextStyle inputHint = TextStyle(
    color: Colors.grey,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  // ============================================================
  // 6. CONTACT LIST ITEMS
  // ============================================================
  static const TextStyle contactName = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w600, // Try: w500, w700
  );

  static const TextStyle contactNumber = TextStyle(
    color: Colors.grey,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle contactInitials = TextStyle(
    color: Color(0xFF00AA4F),
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );
}
