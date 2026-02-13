// File: lib/lib/till_processing_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'qr_processing_screen.dart';

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
            // 1. Spacer to push content down (Matches QrReviewScreen)
            const Spacer(),

            // 2. The Asset Image (Matches QrReviewScreen position, but uses bill_img.png)
            Center(
              child: Image.asset(
                'assets/bill_img.png',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 20),

            // 3. Transaction Details (Preserved Merchant & Till Number logic)
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

                  // Merchant Name
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

                  // Till Number (Dynamic)
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

            // 4. AMOUNT DISPLAY (Matches QrReviewScreen)
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

            // 5. Fee & Tax Section (Matches QrReviewScreen)
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

            // 6. BUTTON POSITIONING (Matches QrReviewScreen EXACTLY)
            // No Spacer() here anymore.

            Padding(
              padding: const EdgeInsets.only(bottom: 90.0, top: 20.0),
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
                  padding: const EdgeInsets.symmetric(vertical: 10), // Reduced vertical padding to match Review Screen
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