import 'package:flutter/material.dart';
import 'dart:math';
import 'main.dart'; // To go back to MainScreen

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

  String get _transactionID => "ID#${Random().nextInt(90000000) + 4000000000}";

  String get _displayDate {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2,'0')} ${_getMonth(now.month)} ${now.year}   ${_formatTime(now)}";
  }

  String _getMonth(int month) {
    const months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    return months[month-1];
  }

  String _formatTime(DateTime date) {
    int hour = date.hour > 12 ? date.hour - 12 : date.hour;
    String amPm = date.hour >= 12 ? "PM" : "AM";
    return "${hour}:${date.minute.toString().padLeft(2,'0')} $amPm";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const EasypaisaApp()),
                    (route) => false,
              );
            },
          ),
        ],
        title: const Text("easypaisa", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: -0.5)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // --- SUCCESS HEADER ---
            const Icon(Icons.check_circle, color: Color(0xFF00AA4F), size: 60),
            const SizedBox(height: 10),
            const Text("Transaction Successful", style: TextStyle(color: Color(0xFF00AA4F), fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text("Money has been sent", style: TextStyle(color: Colors.grey, fontSize: 14)),

            const SizedBox(height: 15),

            // --- DATE & ID ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              color: Colors.grey[50],
              width: double.infinity,
              child: Column(
                children: [
                  Text(_displayDate, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(_transactionID, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // --- DETAILS LIST ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  _buildDetailRow(label: "Funding Source", value: "easypaisa Account", icon: Icons.account_balance_wallet_outlined),
                  _buildDetailRow(label: "Sent to", value: contactName, subValue: contactNumber),
                  _buildDetailRow(label: "Account Details", value: "Shahana Amaan"),
                  _buildDetailRow(label: "Sent by", value: "FATIMA SHAH", subValue: "03025529918"),
                  _buildDetailRow(label: "Amount", value: amount),
                  _buildDetailRow(label: "Fee / Charge", value: "No Charge"),

                  const Divider(color: Colors.grey, thickness: 0.5),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
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

            // --- BOTTOM ACTIONS ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(Icons.share_outlined, "Share"),
                  Container(height: 30, width: 1, color: Colors.grey[300]),
                  _buildActionButton(Icons.image_outlined, "Save to Gallery"),
                  Container(height: 30, width: 1, color: Colors.grey[300]),
                  _buildActionButton(Icons.picture_as_pdf_outlined, "Save as PDF"),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value, String? subValue, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 30, child: icon != null ? Icon(icon, size: 20, color: Colors.grey) : null),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: Colors.black87, fontSize: 14)),
                if (subValue != null) Text(subValue, style: const TextStyle(color: Colors.black87, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.black54, size: 24),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }
}