// File: lib/main_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'send_menu.dart';
import 'screens/my_account_screen.dart';
import 'user_data.dart';
import 'qr_scanner_screen.dart'; // Import the QR scanner screen

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

  Future<void> _handleRefresh() async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      // Optional: Add a light haptic feedback for that "snap" feel
      HapticFeedback.lightImpact();
      setState(() {
        // Here you could refresh data if needed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ==========================================================
    // ALIGNMENT CONTROLS
    // ==========================================================
    double yOffset = 0.0;
    double settingsButtonTop = 30.0;
    double sendMoneyButtonTop = 255.0;

    // LOCKED COORDINATES FOR BALANCE OVERLAY
    double balanceTop = 168.0;
    double balanceLeft = 35.0;
    double balanceWidth = 190.0; // Increased width slightly to fit 6 spaced stars
    double balanceHeight = 30.0;
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
            body: RefreshIndicator(
              onRefresh: _handleRefresh,
              color: Colors.black,
              backgroundColor: Colors.white,
              displacement: 50,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
                  child: Stack(
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
                          SendMenu.show(context);
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
                          child: ValueListenableBuilder<double>(
                            valueListenable: UserData.balance,
                            builder: (context, value, child) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    isBalanceVisible
                                        ? "Rs. ${NumberFormat('#,##0.00').format(value)}"
                                        : "* * * * * *",
                                    style: const TextStyle(
                                      color: Color(0xFFEEEEEE),
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isBalanceVisible = !isBalanceVisible;
                                      });
                                    },
                                    child: Icon(
                                      isBalanceVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: const Color(0xFFEEEEEE),
                                      size: 20,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),

                      // 5. QR Scanner Button (Invisible)
                      _buildInvisibleButton(
                        top: 655,
                        left: 135,
                        width: 100,
                        height: 50,
                        label: "QR Scanner",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const QrScannerScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
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
