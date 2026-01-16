import 'package:flutter/material.dart';
import 'dart:math'; // To generate random Transaction IDs
import 'main.dart'; // To go back to Home

class ReceiptScreen extends StatelessWidget {
  final String amount;
  final String contactName;
  final String contactNumber;

  const ReceiptScreen({
    super.key,
    required this.amount,
    required this.contactName,
    required this.contactNumber,
  });

  // Helper to generate a fake Transaction ID
  String get _transactionID {
    var rng = Random();
    return "ID#${rng.nextInt(90000000) + 10000000}"; // Generates like ID#41782368
  }

  // Helper to get current Date/Time string
  String get _currentDateTime {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2,'0')} Nov ${now.year}  ${now.hour}:${now.minute.toString().padLeft(2,'0')} ${now.hour >= 12 ? 'PM' : 'AM'}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            // GO BACK TO HOME (Resets the flow)
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const EasypaisaApp()),
              (route) => false,
            );
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tiny logo simulation
            CircleAvatar(
              radius: 10,
              backgroundColor: const Color(0xFF00AA4F),
              child: const Text("ep", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 5),
            const Text("easypaisa", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
      body: Column(
        children: [
          // 1. SUCCESS HEADER
          const Icon(Icons.check_circle, color: Color(0xFF00AA4F), size: 60),
          const SizedBox(height: 10),
          const Text("Transaction Successful", style: TextStyle(color: Color(0xFF00AA4F), fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text("Money has been sent", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),

          // 2. DATE AND ID
          Text(_currentDateTime, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(_transactionID, style: const TextStyle(color: Colors.grey, fontSize: 12)),

          const SizedBox(height: 20),

          // 3. DETAILS LIST
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  _buildDetailRow("Funding Source", "easypaisa Account", isIcon: true),
                  _buildDetailRow("Sent to", "$contactName\n$contactNumber", isIcon: false),
                  _buildDetailRow("Account Details", contactName, isIcon: false), // Using Contact Name as placeholder
                  _buildDetailRow("Sent by", "FATIMA SHAH\n03025529918", isIcon: false), // Hardcoded from Screenshot
                  _buildDetailRow("Amount", amount, isIcon: false),
                  _buildDetailRow("Fee / Charge", "No Charge", isIcon: false),

                  const Divider(color: Colors.grey),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Amount", style: TextStyle(color: Color(0xFF00AA4F), fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("Rs. $amount.00", style: const TextStyle(color: Color(0xFF00AA4F), fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. BOTTOM ACTION BUTTONS
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomAction(Icons.share, "Share"),
                _buildBottomAction(Icons.image, "Save to Gallery"),
                _buildBottomAction(Icons.picture_as_pdf, "Save as PDF"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {required bool isIcon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Only show Wallet Icon for the first item
          if (isIcon)
            const Padding(
              padding: EdgeInsets.only(right: 10, top: 2),
              child: Icon(Icons.account_balance_wallet, size: 20, color: Colors.grey),
            ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                Text(value, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 10)),
      ],
    );
  }
}