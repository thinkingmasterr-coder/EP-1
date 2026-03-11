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
    double buttonTopPosition = 493.0;

    // 3. Green tab controls
    double tabWidth = 120.0;
    double tabHeight = 50.0;
    double tabTopPosition = 180.0;
    double tabLeftPosition = 108.0;

    // 4. White tab controls
    double whiteTabWidth = 99.0;
    double whiteTabHeight = 20.0; // Reduced height
    double whiteTabTopPosition = 340.0;
    double whiteTabLeftPosition = 67.0;
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

          // 4. IFTIKHAR KHAN Tab
          Positioned(
            top: tabTopPosition,
            left: tabLeftPosition,
            child: Material(
              color: const Color(0xFF006E59),
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: tabWidth,
                  height: tabHeight,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start, // Left-aligns the content
                    children: const [
                      Text(
                        "IFTIKHAR KHAN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4), // Spacing
                      Text(
                        "03125534518",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 5. White Number Tab
          Positioned(
            top: whiteTabTopPosition,
            left: whiteTabLeftPosition,
            child: Container(
              width: whiteTabWidth,
              height: whiteTabHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text(
                "03125534518",
                style: TextStyle(
                  color: Color(0xFF8A8A8A), // The perfect in-between gray
                  fontWeight: FontWeight.w500,
                  fontSize: 12.0, // 1 point smaller
                  letterSpacing: -0.5,
                ),
              ),
            ),
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