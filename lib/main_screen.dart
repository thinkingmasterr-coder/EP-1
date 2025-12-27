// File: lib/main_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'send_menu.dart';
import 'screens/my_account_screen.dart';
import 'screens/balance_editor_screen.dart';
import 'user_data.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Toggle this to TRUE if you need to see the touch areas again
  bool showDebugBoxes = false;

  // Controls if the balance is shown or hidden (****)
  bool isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    // ==========================================================
    // ALIGNMENT CONTROLS (LOCKED)
    // ==========================================================
    double yOffset = -4.0;
    double settingsButtonTop = 30.0;
    double sendMoneyButtonTop = 255.0;

    // LOCKED COORDINATES FOR BALANCE OVERLAY
    double balanceTop = 185.0;
    double balanceLeft = 30.0;
    double balanceWidth = 180.0;
    double balanceHeight = 30.0;

    // EDITOR BUTTON POSITION
    double editorTop = 450.0;
    double editorLeft = 250.0;
    // ==========================================================

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Stack(
        children: [
          // 1. Background Screenshot
          Positioned(
            top: yOffset,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/home_bg.png',
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),

          // 2. Settings Button
          _buildInvisibleButton(
            top: settingsButtonTop,
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

          // 3. Send Money Button
          _buildInvisibleButton(
            top: sendMoneyButtonTop,
            left: 1,
            width: 150,
            height: 100,
            label: "Send Money",
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const SendMenu(),
              );
            },
          ),

          // 4. THE BALANCE OVERLAY (Gradient Correction)
          Positioned(
            top: balanceTop,
            left: balanceLeft,
            width: balanceWidth,
            height: balanceHeight,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    // LEFT SIDE: LOCKED (Your Perfect Match)
                    Color(0xFF006E59),

                    // RIGHT SIDE: Trying LIGHTER values now
                    // ----------------------------------------------------
                    // Option A: Slightly LIGHTER (Try this first)
                    Color(0xFF006E59),

                    // Option B: Even LIGHTER (If A is still too dark)
                    // Color(0xFF007656),

                    // Option C: Lighter & Less Blue (Warmer)
                    // Color(0xFF007250),
                    // ----------------------------------------------------
                  ],
                ),
              ),

              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 0),

              child: ValueListenableBuilder<double>(
                valueListenable: UserData.balance,
                builder: (context, value, child) {
                  return Row(
                    children: [
                      // The Balance Text
                      Text(
                        isBalanceVisible
                            ? "Rs. ${NumberFormat('#,##0.00').format(value)}"
                            : "Rs. ****",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 10),

                      // The Eye Icon
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isBalanceVisible = !isBalanceVisible;
                          });
                        },
                        child: Icon(
                          isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // 5. Hidden "Balance Editor" Button
          _buildInvisibleButton(
            top: editorTop,
            left: editorLeft,
            width: 100,
            height: 50,
            label: "Edit Balance",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BalanceEditorScreen()),
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