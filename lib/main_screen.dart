// File: lib/main_screen.dart
import 'package:flutter/material.dart';
import 'send_menu.dart';
import 'screens/my_account_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Toggle this to false when you want to hide the red debugging boxes
  bool showDebugBoxes = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Screenshot
          Positioned.fill(
            child: Image.asset(
              'assets/home_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Settings Button (Top Left Profile Icon)
          _buildInvisibleButton(
            top: 30,
            left: 5,
            width: 60,
            height: 60,
            label: "Settings",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyAccountScreen())
              );
            },
          ),

          // 3. Send Money Button (The Paper Plane Card)
          _buildInvisibleButton(
            top: 255,
            left: 1,
            width: 150,
            height: 100,
            label: "Send Money",
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true, // Needed for custom height
                backgroundColor: Colors.transparent, // Ensures corners are visible
                // transitionAnimationController: ... (System handles the slide default)
                builder: (context) => const SendMenu(),
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
          color: showDebugBoxes ? Colors.red.withOpacity(0.5) : Colors.transparent,
          child: showDebugBoxes
              ? Center(
            child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)
            ),
          )
              : null,
        ),
      ),
    );
  }
}