import 'package:flutter/material.dart';
import 'transfer_screen.dart'; // IMPORTANT: This connects the files

class SendMenu extends StatelessWidget {
  const SendMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Takes only as much space as needed
        children: [
          // The Handle Bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 20),

          const Text("Send Money To", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // The Grid of Options
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildOption(context, Icons.account_balance_wallet, "easypaisa\nTransfer", isActive: true),
                    _buildOption(context, Icons.account_balance, "Bank\nTransfer", isActive: false),
                    _buildOption(context, Icons.badge, "CNIC\nTransfer", isActive: false),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildOption(context, Icons.payment, "Raast\nPayment", isActive: false),
                    _buildOption(context, Icons.card_giftcard, "Tohfa\n", isActive: false),
                    _buildOption(context, Icons.wallet, "Other\nWallets", isActive: false),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                     _buildOption(context, Icons.qr_code_scanner, "Scan QR\n", isActive: false),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // This is the function that handles the clicking
  Widget _buildOption(BuildContext context, IconData icon, String label, {required bool isActive}) {
    return GestureDetector(
      onTap: () {
        if (isActive) {
          // 1. Close the white popup menu
          Navigator.pop(context);

          // 2. Open the new "Transfer Screen"
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TransferScreen()),
          );
        } else {
          // Shows "No Internet" for other buttons
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No Internet Connection"), duration: Duration(seconds: 1)),
          );
        }
      },
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Icon(icon, color: const Color(0xFF2D333A)), // Dark grey icons
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}