import 'package:flutter/material.dart';

// This class acts as the "Brain" of the app.
// It stores the balance and contacts so they can be edited from anywhere.

class UserData {
  // 1. THE BALANCE
  // We use ValueNotifier so the screen updates automatically when this number changes.
  static ValueNotifier<double> balance = ValueNotifier(6.46);

  // 2. THE CONTACTS
  // Added "accountTitle" for the official name on the receipt
  static List<Map<String, String>> contacts = [
    {
      "name": "Shehzad Khan",
      "number": "03001234567",
      "initials": "SK",
      "accountTitle": "SHEHZAD KHAN",
    },
    {
      "name": "Syed Rasool",
      "number": "03119876543",
      "initials": "SR",
      "accountTitle": "SYED RASOOL SHAH",
    },
    {
      "name": "Nana",
      "number": "03109192826",
      "initials": "N",
      "accountTitle": "GUL ZAMAN",
    },
    {
      "name": "Abbas Bacha",
      "number": "03139162159",
      "initials": "AB",
      "accountTitle": "MUHAMMAD ABBAS",
    },
    {
      "name": "Ahmed Ali",
      "number": "03367631215",
      "initials": "AA",
      "accountTitle": "AHMED ALI",
    },
    {
      "name": "Ahmed2 Awkum",
      "number": "03025736656",
      "initials": "AA",
      "accountTitle": "AHMED KHAN",
    },
    {
      "name": "Annonomy 53",
      "number": "03149007912",
      "initials": "A5",
      "accountTitle": "ANONYMOUS USER",
    },
    {
      "name": "Noreen Akbar",
      "number": "03440644461",
      "initials": "NA",
      "accountTitle": "NOREEN AKBAR",
    },
  ];

  // 3. TOOLS
  static void setBalance(double newAmount) {
    balance.value = newAmount;
  }

  static void deductBalance(double amount) {
    balance.value -= amount;
  }
}