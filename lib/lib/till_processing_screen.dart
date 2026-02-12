// File: lib/till_processing_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'qr_processing_screen.dart'; // We reuse the success animation screen for now

class TillProcessingScreen extends StatelessWidget {
  final String amount;
  final String tillNumber;

  const TillProcessingScreen({
    super.key,
    required this.amount,
    required this.tillNumber,
  });

  @override
  Widget build(BuildContext context) {
    final double amountValue = double.tryParse(amount) ?? 0;
    final NumberFormat currencyFormat = NumberFormat("#,##0", "en_US");
    final NumberFormat currencyFormatWithDecimals = NumberFormat("#,##0.00", "en_US");

    final String formattedAmount = currencyFormat.format(amountValue);
    final String formattedTotalAmount = currencyFormatWithDecimals.format(amountValue);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // 1. CHANGED: Title to "Till Payment"
        title: const Text(
          'Till Payment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Help', style: TextStyle(color: Colors.black)),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),

            // 3. CHANGED: Empty area instead of QR Code
            const Center(
              child: SizedBox(
                height: 120,
                width: 120,
                // Empty as requested
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transaction Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 2. CHANGED: "Merchant Name" -> "AK MOBILE CENTRE CHD"
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Merchant Name',
                          style: TextStyle(color: Colors.black54, fontSize: 13)),
                      Text('AK MOBILE CENTRE CHD',
                          style: TextStyle(color: Colors.black54, fontSize: 13)),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // 2. CHANGED: "Till Number" -> Dynamic Value
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Till Number',
                          style: TextStyle(color: Colors.black54, fontSize: 13)),
                      Text(tillNumber,
                          style: const TextStyle(color: Colors.black54, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // AMOUNT DISPLAY
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Rs.',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  formattedAmount,
                  style: const TextStyle(
                      fontSize: 54,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Divider(),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Fee & Tax', style: TextStyle(fontSize: 15)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Free',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Amount',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('Rs. $formattedTotalAmount',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),

            const Divider(),
            const Spacer(),

            // PAY BUTTON
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the Success Animation Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QrProcessingScreen(
                        amount: amount,
                        recipientName: "AK MOBILE CENTER CHD",
                        recipientLocation: "Till Payment",
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00AA4F),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Pay Now',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}