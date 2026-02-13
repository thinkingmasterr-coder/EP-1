// File: lib/send_menu.dart
import 'package:flutter/material.dart';
import 'transfer_screen.dart';
import 'qr_scanner_screen.dart';

class SendMenu extends StatelessWidget {
  const SendMenu({super.key});

  // =======================================================
  // 🔧 CONTROL PANEL
  // =======================================================
  static const double scaleFactor = 1.0;
  static const double verticalAlignment = 0.5;
  // =======================================================

  // HELPER: This forces the "Pop in" effect (NO SLIDING)
  static void show(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) => const SendMenu(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // CHANGED: 0.6 -> 0.3 (Less dark, more visible background)
      backgroundColor: Colors.black.withOpacity(0.3),
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        behavior: HitTestBehavior.opaque,
        child: Align(
          alignment: Alignment(0.0, verticalAlignment),
          child: GestureDetector(
            onTap: () {},
            child: Transform.scale(
              scale: scaleFactor,
              child: SizedBox(
                width: 340,
                height: 400,
                child: Stack(
                  children: [
                    // 1. THE BACKGROUND IMAGE
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/send_menu_bg.png',
                          width: 340,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),

                    // 2. INVISIBLE BUTTON (Easypaisa Transfer)
                    Positioned(
                      top: 40,
                      left: 20,
                      width: 90,
                      height: 90,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const TransferScreen()));
                        },
                        child: Container(color: Colors.transparent),
                      ),
                    ),

                    // 3. INVISIBLE BUTTON (Scan QR)
                    Positioned(
                      top: 255,
                      left: 30,
                      width: 90,
                      height: 90,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const QrScannerScreen()));
                        },
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}