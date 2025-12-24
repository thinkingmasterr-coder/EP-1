// File: lib/send_menu.dart
import 'package:flutter/material.dart';
import 'transfer_screen.dart';

class SendMenu extends StatelessWidget {
  const SendMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
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
                // ==========================================================
                // PINPOINT 1: BUTTON POSITION
                // Change 'top' to move the invisible button UP or DOWN.
                // Decrease (e.g. 30) = Moves UP
                // Increase (e.g. 70) = Moves DOWN
                // ==========================================================
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
                    // Debug: Set to Colors.red.withOpacity(0.5) to see the box
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ==========================================================
        // PINPOINT 2: MENU POSITION
        // Change 'height' to lift the entire menu off the bottom of the screen.
        // Increase (e.g. 50) = Lifts the whole menu HIGHER
        // Set to 0 = Menu sticks to the very BOTTOM
        // ==========================================================
        const SizedBox(height: 100),
      ],
    );
  }
}