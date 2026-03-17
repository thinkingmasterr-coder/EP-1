import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/transaction_model.dart';

class UserData {
  // 1. THE BALANCE
  static ValueNotifier<double> balance = ValueNotifier(0.00);

  // 2. THE CONTACTS
  static ValueNotifier<List<Map<String, String>>> contacts = ValueNotifier([]);

  // 3. QR STORE INFO
  static ValueNotifier<String> qrStoreName = ValueNotifier("ZAHID GENERAL STORE");
  static ValueNotifier<String> qrTillNumber = ValueNotifier("12345");

  // 4. USER INFO
  static ValueNotifier<String> userName = ValueNotifier("IFTIKHAR KHAN");
  static ValueNotifier<String> userNumber = ValueNotifier("03125534518");

  // 5. TRANSACTIONS
  static ValueNotifier<List<TransactionModel>> transactions = ValueNotifier([]);

  // DEFAULT CONTACTS (20 PRE-FILLED)
  static final List<Map<String, String>> _defaultContacts = [
    {"name": "Shehzad Khan", "number": "03001234567", "initials": "SK", "accountTitle": "SHEHZAD KHAN"},
    {"name": "Syed Rasool", "number": "03119876543", "initials": "SR", "accountTitle": "SYED RASOOL SHAH"},
    {"name": "Muhammad Ali", "number": "03451122334", "initials": "MA", "accountTitle": "MUHAMMAD ALI"},
    {"name": "Abdur Rehman", "number": "03335554433", "initials": "AR", "accountTitle": "ABDUR REHMAN"},
    {"name": "Zahid Hussain", "number": "03017788990", "initials": "ZH", "accountTitle": "ZAHID HUSSAIN"},
    {"name": "Faisal Iqbal", "number": "03214455667", "initials": "FI", "accountTitle": "FAISAL IQBAL"},
    {"name": "Usman Sheikh", "number": "03123344556", "initials": "US", "accountTitle": "USMAN SHEIKH"},
    {"name": "Bilal Ahmed", "number": "03021112223", "initials": "BA", "accountTitle": "BILAL AHMED"},
    {"name": "Imran Abbas", "number": "03448899001", "initials": "IA", "accountTitle": "IMRAN ABBAS"},
    {"name": "Sajid Mehmood", "number": "03316677889", "initials": "SM", "accountTitle": "SAJID MEHMOOD"},
    {"name": "Kamran Akmal", "number": "03225544332", "initials": "KA", "accountTitle": "KAMRAN AKMAL"},
    {"name": "Hamza Yusuf", "number": "03159988776", "initials": "HY", "accountTitle": "HAMZA YUSUF"},
    {"name": "Arsalan Shah", "number": "03052233445", "initials": "AS", "accountTitle": "ARSALAN SHAH"},
    {"name": "Babar Azam", "number": "03401122446", "initials": "BA", "accountTitle": "BABAR AZAM"},
    {"name": "Rizwan Ahmed", "number": "03356677112", "initials": "RA", "accountTitle": "RIZWAN AHMED"},
    {"name": "Shoaib Malik", "number": "03247788993", "initials": "SM", "accountTitle": "SHOAIB MALIK"},
    {"name": "Asif Ali", "number": "03104455661", "initials": "AA", "accountTitle": "ASIF ALI"},
    {"name": "Naseem Shah", "number": "03061122338", "initials": "NS", "accountTitle": "NASEEM SHAH"},
    {"name": "Shaheen Afridi", "number": "03429988774", "initials": "SA", "accountTitle": "SHAHEEN AFRIDI"},
    {"name": "Haris Rauf", "number": "03325544119", "initials": "HR", "accountTitle": "HARIS RAUF"},
  ];

  // DEFAULT DUMMY TRANSACTIONS (20 PRE-FILLED)
  static final List<TransactionModel> _defaultTransactions = [
    TransactionModel(type: "Money Transfer", bankName: "easypaisa", receiverName: "Ahmed Raza", contactNumber: "03001112223", dateTime: DateTime.now().subtract(const Duration(hours: 2)), amount: 500.0, isSent: true, isDummy: true),
    TransactionModel(type: "Raast QR Payment", bankName: "easypaisa", receiverName: "Zahid General Store", contactNumber: "", dateTime: DateTime.now().subtract(const Duration(hours: 5)), amount: 1250.0, isSent: true, isDummy: true),
    TransactionModel(type: "Money Transfer", bankName: "easypaisa", receiverName: "Salman Khan", contactNumber: "03124445556", dateTime: DateTime.now().subtract(const Duration(days: 1)), amount: 2000.0, isSent: false, isDummy: true),
    TransactionModel(type: "Easypaisa Mobile Load", bankName: "easypaisa", receiverName: "Telenor Topup", contactNumber: "03456677889", dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 3)), amount: 100.0, isSent: true, isDummy: true),
    TransactionModel(type: "Money Transfer", bankName: "easypaisa", receiverName: "Omar Farooq", contactNumber: "03331234567", dateTime: DateTime.now().subtract(const Duration(days: 2)), amount: 15000.0, isSent: false, isDummy: true),
    TransactionModel(type: "Money Transfer", bankName: "easypaisa", receiverName: "Kashif Ali", contactNumber: "03215556667", dateTime: DateTime.now().subtract(const Duration(days: 2, hours: 4)), amount: 350.0, isSent: true, isDummy: true),
    TransactionModel(type: "Raast QR Payment", bankName: "easypaisa", receiverName: "Gourmet Bakers", contactNumber: "", dateTime: DateTime.now().subtract(const Duration(days: 3)), amount: 890.0, isSent: true, isDummy: true),
    TransactionModel(type: "Money Transfer", bankName: "easypaisa", receiverName: "Yasir Shah", contactNumber: "03018889990", dateTime: DateTime.now().subtract(const Duration(days: 3, hours: 1)), amount: 5000.0, isSent: true, isDummy: true),
    TransactionModel(type: "Money Transfer", bankName: "easypaisa", receiverName: "Bilal Jan", contactNumber: "03117774441", dateTime: DateTime.now().subtract(const Duration(days: 4)), amount: 1200.0, isSent: false, isDummy: true),
    TransactionModel(type: "Easypaisa Mobile Load", bankName: "easypaisa", receiverName: "Zong Load", contactNumber: "03129990001", dateTime: DateTime.now().subtract(const Duration(days: 4, hours: 6)), amount: 200.0, isSent: true, isDummy: true),
    TransactionModel(type: "Money Transfer", bankName: "easypaisa", receiverName: "Mustafa Kamal", contactNumber: "03442223334", dateTime: DateTime.now().subtract(const Duration(days: 5)), amount: 7500.0, isSent: true, isDummy: true),
    TransactionModel(type: "Money Transfer", bankName: "easypaisa", receiverName: "Junaid Jamshed", contactNumber: "03314445558", dateTime: DateTime.now().subtract(const Duration(days: 6)), amount: 1000.0, isSent: false, isDummy: true),
    TransactionModel(type: "Raast QR Payment", bankName: "easypaisa", receiverName: "Imtiaz Super Market", contactNumber: "", dateTime: DateTime.now().subtract(const Duration(days: 7)), amount: 4500.0, isSent: true, isDummy: true),
    TransactionModel(type: "Money Transfer", bankName: "easypaisa", receiverName: "Sanaullah Khan", contactNumber: "03221110009", dateTime: DateTime.now().subtract(const Duration(days: 8)), amount: 250.0, isSent: true, isDummy: true),
    TransactionModel(type: "Money Transfer", bankName: "easypaisa", receiverName: "Rizwan Ullah", contactNumber: "03158887776", dateTime: DateTime.now().subtract(const Duration(days: 9)), amount: 3000.0, isSent: false, isDummy: true),
    TransactionModel(type: "Easypaisa Mobile Load", bankName: "easypaisa", receiverName: "Jazz Load", contactNumber: "03004445551", dateTime: DateTime.now().subtract(const Duration(days: 10)), amount: 500.0, isSent: true, isDummy: true),
    TransactionModel(type: "Money Transfer", bankName: "easypaisa", receiverName: "Tariq Mahmood", contactNumber: "03401239874", dateTime: DateTime.now().subtract(const Duration(days: 11)), amount: 1800.0, isSent: true, isDummy: true),
    TransactionModel(type: "Money Transfer", bankName: "easypaisa", receiverName: "Waqas Ahmed", contactNumber: "03356667772", dateTime: DateTime.now().subtract(const Duration(days: 12)), amount: 600.0, isSent: false, isDummy: true),
    TransactionModel(type: "Raast QR Payment", bankName: "easypaisa", receiverName: "Shell Petrol Pump", contactNumber: "", dateTime: DateTime.now().subtract(const Duration(days: 13)), amount: 2000.0, isSent: true, isDummy: true),
    TransactionModel(type: "Money Transfer", bankName: "easypaisa", receiverName: "Adnan Siddiqui", contactNumber: "03248883331", dateTime: DateTime.now().subtract(const Duration(days: 14)), amount: 4200.0, isSent: true, isDummy: true),
  ];

  static Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // LOAD BALANCE
    double? savedBalance = prefs.getDouble('my_balance');
    balance.value = savedBalance ?? 6.46;

    // LOAD CONTACTS
    String? savedContactsString = prefs.getString('my_contacts');
    List<Map<String, String>> loadedContacts = [];
    if (savedContactsString != null) {
      List<dynamic> decoded = jsonDecode(savedContactsString);
      loadedContacts = decoded.map((item) => Map<String, String>.from(item)).toList();
    }
    
    // Merge defaults
    bool contactsMerged = false;
    for (var defaultContact in _defaultContacts) {
      if (!loadedContacts.any((c) => c['number'] == defaultContact['number'])) {
        loadedContacts.add(defaultContact);
        contactsMerged = true;
      }
    }
    contacts.value = loadedContacts;
    if (contactsMerged) {
      await prefs.setString('my_contacts', jsonEncode(loadedContacts));
    }

    // LOAD QR STORE INFO
    qrStoreName.value = prefs.getString('qr_store_name') ?? "ZAHID GENERAL STORE";
    qrTillNumber.value = prefs.getString('qr_till_number') ?? "12345";

    // LOAD USER INFO
    userName.value = prefs.getString('user_name') ?? "IFTIKHAR KHAN";
    userNumber.value = prefs.getString('user_number') ?? "03125534518";

    // LOAD TRANSACTIONS
    String? transactionsString = prefs.getString('transactions');
    List<TransactionModel> loadedTxs = [];
    if (transactionsString != null) {
      List<dynamic> decoded = jsonDecode(transactionsString);
      loadedTxs = decoded.map((item) => TransactionModel.fromJson(item)).toList();
    }

    // FORCE ADD DEFAULTS if they don't exist by receiverName
    bool txMerged = false;
    for (var defaultTx in _defaultTransactions) {
      bool exists = loadedTxs.any((tx) => 
        tx.isDummy && 
        tx.receiverName == defaultTx.receiverName
      );
      if (!exists) {
        loadedTxs.add(defaultTx);
        txMerged = true;
      }
    }
    
    // Sort transactions by date (newest first)
    loadedTxs.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    transactions.value = loadedTxs;
    
    if (txMerged) {
      await prefs.setString('transactions', jsonEncode(loadedTxs.map((tx) => tx.toJson()).toList()));
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
    await setBalance(newBalance);
  }

  // SAVE QR STORE INFO
  static Future<void> setQrStoreInfo(String name, String till) async {
    qrStoreName.value = name;
    qrTillNumber.value = till;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('qr_store_name', name);
    await prefs.setString('qr_till_number', till);
  }

  // SAVE USER INFO
  static Future<void> setUserInfo(String name, String number) async {
    userName.value = name;
    userNumber.value = number;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_number', number);
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

  // --- TRANSACTIONS HELPERS ---
  static Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    String encoded = jsonEncode(transactions.value.map((tx) => tx.toJson()).toList());
    await prefs.setString('transactions', encoded);
  }

  static Future<void> addTransaction(TransactionModel tx) async {
    final currentList = List<TransactionModel>.from(transactions.value);
    currentList.insert(0, tx); // Insert at the top
    transactions.value = currentList;
    await _saveTransactions();
  }

  static Future<void> updateTransaction(int index, TransactionModel tx) async {
    final currentList = List<TransactionModel>.from(transactions.value);
    if (index >= 0 && index < currentList.length) {
      currentList[index] = tx;
      transactions.value = currentList;
      await _saveTransactions();
    }
  }

  static Future<void> deleteTransaction(int index) async {
    final currentList = List<TransactionModel>.from(transactions.value);
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      transactions.value = currentList;
      await _saveTransactions();
    }
  }

  static Future<void> clearTransactions() async {
    transactions.value = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('transactions');
  }
}
