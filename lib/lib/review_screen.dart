// File: lib/review_screen.dart
import 'package:flutter/material.dart';
import 'user_data.dart';
import 'processing_screen.dart';

class ReviewScreen extends StatelessWidget {
  final String contactName;
  final String contactNumber;
  final String amount;

  const ReviewScreen({
    super.key,
    required this.contactName,
    required this.contactNumber,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Logic to find the real Account Title
    String accountTitle = contactName; // Default fallback
    try {
      // FIXED: Use .value to access the list from the ValueNotifier
      final contact = UserData.contacts.value.firstWhere(
            (c) => c['number'] == contactNumber,
      );
      // If we found a specific Account Title, use it. Otherwise use the saved name.
      if (contact['accountTitle'] != null && contact['accountTitle']!.isNotEmpty) {
        accountTitle = contact['accountTitle']!;
      }
    } catch (e) {
      // Contact not found in list, stick with the passed name
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      // [FIX] This prevents the "Split Second Error" caused by the keyboard closing
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("easypaisa Transfer", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PAY FROM BOX
            const Text("Pay From", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12, width: 1),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/wallet_ik.png',
                    width: 41,
                    height: 41,
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("easypaisa Account"),
                      ValueListenableBuilder<double>(
                        valueListenable: UserData.balance,
                        builder: (context, value, child) {
                          return Text("Balance Rs. ${value.toStringAsFixed(2)}", style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold));
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // PAY TO BOX
            const Text("Pay To", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Account Title", style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.normal, letterSpacing: -0.2)),
                      Text(accountTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, letterSpacing: -0.2)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Account Number", style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.normal, letterSpacing: -0.2)),
                      Text(contactNumber, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, letterSpacing: -0.2)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // PAYMENT SUMMARY
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text("Payment Summary", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12, width: 1),
              ),
              child: Column(
                children: [
                  _buildSummaryRow("Transfer amount", "Rs. $amount"),
                  _buildSummaryRow("Fee (including tax)", "Free"),
                  _buildSummaryRow("Total Amount", "Rs. $amount.00", isBold: true),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // FAVORITE CONTACT
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12, width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF00AA4F), width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Favorite Contact",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Add the recipent as a favourite for easy payments in the future.",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // SEND NOW BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00AA4F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  // START THE ANIMATION
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProcessingScreen(
                        amount: amount,
                        contactName: contactName,
                        contactNumber: contactNumber,
                      ),
                    ),
                  );
                },
                child: const Text("Send Now", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 14,
              letterSpacing: -0.2,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 14,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
