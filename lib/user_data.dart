import 'dart:convert'; // Required to turn the list into text
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  // 1. THE BALANCE
  static ValueNotifier<double> balance = ValueNotifier(0.00);

  // 2. THE CONTACTS
  static ValueNotifier<List<Map<String, String>>> contacts = ValueNotifier([]);

  // DEFAULT CONTACTS (If the app is opened for the very first time)
  static final List<Map<String, String>> _defaultContacts = [
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
    // ... You can keep your other defaults here if you want
  ];

  // ==========================================================
  // 💾 THE SAVING & LOADING SYSTEM
  // ==========================================================

  // Call this once when the app starts!
  static Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // A. LOAD BALANCE (Default to 6.46 if nothing is saved)
    double? savedBalance = prefs.getDouble('my_balance');
    if (savedBalance != null) {
      balance.value = savedBalance;
    } else {
      balance.value = 6.46; // Your starting default
    }

    // B. LOAD CONTACTS
    String? savedContactsString = prefs.getString('my_contacts');
    if (savedContactsString != null) {
      // Decode the text back into a List
      List<dynamic> decoded = jsonDecode(savedContactsString);
      // Convert dynamic list to List<Map<String, String>>
      contacts.value = decoded.map((item) => Map<String, String>.from(item)).toList();
    } else {
      // If no contacts saved, use defaults
      contacts.value = List.from(_defaultContacts);
    }
  }

  // SAVE BALANCE
  static Future<void> setBalance(double newAmount) async {
    balance.value = newAmount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('my_balance', newAmount);
  }

  static Future<void> deductBalance(double amount) async {
    double newBalance = balance.value - amount;
    setBalance(newBalance); // This handles the saving automatically
  }

  // PRIVATE HELPER TO SAVE CONTACTS
  static Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    String encodedList = jsonEncode(contacts.value);
    await prefs.setString('my_contacts', encodedList);
  }

  // SAVE NEW CONTACT
  static Future<void> addContact(Map<String, String> newContact) async {
    final currentList = List<Map<String, String>>.from(contacts.value);
    currentList.add(newContact);
    contacts.value = currentList;
    await _saveContacts();
  }

  // UPDATE CONTACT
  static Future<void> updateContact(int index, Map<String, String> contactData) async {
    final currentList = List<Map<String, String>>.from(contacts.value);
    if (index >= 0 && index < currentList.length) {
      currentList[index] = contactData;
      contacts.value = currentList;
      await _saveContacts();
    }
  }

  // DELETE CONTACT
  static Future<void> deleteContact(int index) async {
    final currentList = List<Map<String, String>>.from(contacts.value);
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      contacts.value = currentList;
      await _saveContacts();
    }
  }
}