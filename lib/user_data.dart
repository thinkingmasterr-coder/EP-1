import 'package:flutter/material.dart';

// This class acts as the "Brain" of the app.
// It stores the balance and contacts so they can be edited from anywhere.

class UserData {
  // 1. THE BALANCE
  // We use ValueNotifier so the screen updates automatically when this number changes.
  static ValueNotifier<double> balance = ValueNotifier(6.46);

  // 2. THE CONTACTS
  // A simple list to store people you can send money to.
  static List<Map<String, String>> contacts = [
    {
      "name": "Shehzad Khan",
      "number": "03001234567",
      "initials": "SK", // We will use this if there is no picture
    },
    {
      "name": "Syed Rasool",
      "number": "03119876543",
      "initials": "SR",
    },
    {
      "name": "Nana",
      "number": "03109192826",
      "initials": "N",
    },
  ];

  // 3. TOOLS
  // Function to update balance (used by the hidden editor)
  static void setBalance(double newAmount) {
    balance.value = newAmount;
  }

  // Function to deduct money (used when sending money)
  static void deductBalance(double amount) {
    balance.value -= amount;
  }
}