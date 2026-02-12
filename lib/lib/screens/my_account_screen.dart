// File: lib/screens/my_account_screen.dart
import 'package:flutter/material.dart';
import 'history_screen.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  bool showDebugBoxes = false;

  @override
  Widget build(BuildContext context) {
    // ==========================================================
    // ALIGNMENT CONTROLS
    // ==========================================================
    // 1. Use a NEGATIVE number to push the image UP (hiding the status bar)
    //    Example: -30.0 usually hides the clock/battery area.
    double yOffset = 40.0;

    // 2. Adjust this to match the invisible button to the image
    double buttonTopPosition = 640.0;
    // ==========================================================

    return Scaffold(
      // Set a background color to hide any "film reel" gaps if you pull it down too far
      backgroundColor: const Color(0xFFF3F4F6),
      body: Stack(
        children: [
          // 1. Background Screenshot
          Positioned(
            top: yOffset ,
            left: 0,
            right: 0,
            // REMOVED 'height: screenHeight' to let the image be as tall as it needs to be
            child: Image.asset(
              'assets/settings_bg.jpg', // Make sure this is the UNCROPPED original
              fit: BoxFit.fitWidth,      // Matches width perfectly (fixes button alignment)
              alignment: Alignment.topCenter,
            ),
          ),

          // 2. Back Button
          Positioned(
            top: 40, // Keep this safe from the status bar
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.transparent),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 3. Transaction History Invisible Button
          _buildInvisibleButton(
            top: buttonTopPosition,
            left: 0,
            width: MediaQuery.of(context).size.width,
            height: 60,
            label: "Transaction History",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInvisibleButton({
    required double top,
    required double left,
    required double width,
    required double height,
    required String label,
    required VoidCallback onTap
  }) {
    return Positioned(
      top: top,
      left: left,
      width: width,
      height: height,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: showDebugBoxes ? Colors.red.withOpacity(0.4) : Colors.transparent,
          child: showDebugBoxes
              ? Center(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
              : null,
        ),
      ),
    );
  }
}