// File: lib/send_menu.dart
import 'package:flutter/material.dart';
import 'transfer_screen.dart';
import 'qr_scanner_screen.dart';

class SendMenu extends StatelessWidget {
  const SendMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            width: double.infinity,
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // 1. THE SCREENSHOT BACKGROUND
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(
                    'assets/send_menu_bg.png',
                    fit: BoxFit.cover,
                  ),
                ),

                // 2. THE INVISIBLE BUTTON (Easypaisa Transfer)
                Positioned(
                  top: 50,
                  left: 20,
                  width: 90,
                  height: 90,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close menu
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TransferScreen()));
                    },
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                
                // 3. THE INVISIBLE BUTTON (Scan QR)
                Positioned(
                  top: 295,
                  left: 30, // Positioned to the right of the first button
                  width: 90,
                  height: 90,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close menu
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const QrScannerScreen()));
                    },
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
