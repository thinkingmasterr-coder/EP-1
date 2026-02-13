// File: lib/main_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    // ALIGNMENT CONTROLS
    // ==========================================================
    double yOffset = 0.0;
    double settingsButtonTop = 30.0;
    double sendMoneyButtonTop = 255.0;

    // LOCKED COORDINATES FOR BALANCE OVERLAY (From your request)
    double balanceTop = 168.0;
    double balanceLeft = 35.0;
    double balanceWidth = 190.0;
    double balanceHeight = 30.0;

    // EDITOR BUTTON POSITION
    double editorTop = 450.0;
    double editorLeft = 250.0;
    // ==========================================================

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Container(
        color: Colors.black,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFFF3F4F6),
            body: Stack(
              children: [
                // 1. Background Screenshot
                Positioned(
                  top: yOffset,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/home_bg.jpg',
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

                // 4. THE BALANCE OVERLAY
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
                          Color(0xFF006E59),
                          Color(0xFF006E59),
                        ],
                      ),
                    ),

                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 0),

                    child: ValueListenableBuilder<double>(
                      valueListenable: UserData.balance,
                      builder: (context, value, child) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // The Balance Text
                            Text(
                              isBalanceVisible
                                  ? "Rs. ${NumberFormat('#,##0.00').format(value)}"
                                  : "Rs. ****",
                              style: const TextStyle(
                                color: Color(0xFFEEEEEE), // CHANGED: Slightly less bright white
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(width: 8),

                            // The Eye Icon
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isBalanceVisible = !isBalanceVisible;
                                });
                              },
                              child: Icon(
                                isBalanceVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFFEEEEEE), // CHANGED: Matches the text color
                                size: 20,
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
          ),
        ),
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