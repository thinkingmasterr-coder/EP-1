// File: lib/qr_scanner_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'qr_result_screen.dart';
import 'till_payment_screen.dart'; // <--- Import the Till Screen

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _hasScanned = false;
  bool _showRedLine = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startFlicker();
    });
  }

  void _startFlicker() async {
    while (mounted) {
      // 1. Keep Visible (Longer duration)
      await Future.delayed(const Duration(milliseconds: 1000));

      if (!mounted) break;

      // 2. Make Invisible (Short duration)
      setState(() {
        _showRedLine = false;
      });
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) break;

      // 3. Make Visible again
      setState(() {
        _showRedLine = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Scan QR To Make Payment',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 1. The Camera
          MobileScanner(
            onDetect: (capture) {
              if (_hasScanned) return;

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? qrCode = barcodes.first.rawValue;
                if (qrCode != null) {
                  setState(() {
                    _hasScanned = true;
                  });

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QrResultScreen(qrCode: qrCode),
                    ),
                  );
                }
              }
            },
          ),

          // 2. The Overlay UI
          Column(
            children: [
              // TOP BAR
              Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.8),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    const Text(
                      'Scan any of the following QR Codes',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('digital bank',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(width: 8),
                        Text('VISA',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(width: 8),
                        Text('MasterCard',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(width: 8),
                        Text('Raast',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),

              // MIDDLE SECTION
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double availableHeight = constraints.maxHeight;
                    const double boxSize = 250.0;
                    final double verticalPad = (availableHeight > boxSize)
                        ? (availableHeight - boxSize) / 2
                        : 0;

                    return Column(
                      children: [
                        // Space Above Box
                        Container(
                            height: verticalPad,
                            color: Colors.black.withOpacity(0.5)),

                        // The Row containing the Box
                        SizedBox(
                          height: boxSize,
                          child: Row(
                            children: [
                              // Left of Box
                              Expanded(
                                  child: Container(
                                      color: Colors.black.withOpacity(0.5))),

                              // THE SCANNER BOX
                              Container(
                                width: boxSize,
                                height: boxSize,
                                color: Colors.transparent,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // The 4 Green Corners
                                    _buildCorner(true, true),
                                    _buildCorner(true, false),
                                    _buildCorner(false, true),
                                    _buildCorner(false, false),

                                    // The Flickering Red Line
                                    AnimatedOpacity(
                                      opacity: _showRedLine ? 1.0 : 0.0,
                                      duration: const Duration(milliseconds: 200),
                                      child: Container(
                                        width: 250,
                                        height: 2,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.red.withOpacity(0.5),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Right of Box
                              Expanded(
                                  child: Container(
                                      color: Colors.black.withOpacity(0.5))),
                            ],
                          ),
                        ),

                        // Space Below Box
                        Expanded(
                            child: Container(
                                color: Colors.black.withOpacity(0.5))),
                      ],
                    );
                  },
                ),
              ),

              // BOTTOM BAR
              Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.8),
                padding: const EdgeInsets.only(
                    top: 20, bottom: 30, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // [CHANGED] Using asset path for the Till Icon
                    _buildBottomNavItem(
                      'assets/till_icon.png', // <--- REPLACE THIS WITH YOUR IMAGE
                      'Enter Till\nNumber',
                      onTap: () {
                        // Navigate to Till Payment Screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TillPaymentScreen())
                        );
                      },
                    ),
                    _buildBottomNavItem(Icons.image, 'Scan from\nGallery'),
                    _buildBottomNavItem(
                        Icons.receipt_long, 'Refund\nManagement'),
                    _buildBottomNavItem(Icons.more_horiz, 'More'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(bool top, bool left) {
    const double size = 30.0;
    const double thickness = 4.0;
    const Color color = Colors.green;

    return Positioned(
      top: top ? 0 : null,
      bottom: top ? null : 0,
      left: left ? 0 : null,
      right: left ? null : 0,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border(
            top: top ? BorderSide(color: color, width: thickness) : BorderSide.none,
            bottom: !top ? BorderSide(color: color, width: thickness) : BorderSide.none,
            left: left ? BorderSide(color: color, width: thickness) : BorderSide.none,
            right: !left ? BorderSide(color: color, width: thickness) : BorderSide.none,
          ),
        ),
      ),
    );
  }

  // [CHANGED] Now accepts dynamic iconOrAsset (IconData OR String)
  Widget _buildBottomNavItem(dynamic iconOrAsset, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // LOGIC: Check if it's an IconData or a String (Asset Path)
          if (iconOrAsset is IconData)
            Icon(iconOrAsset, color: Colors.white, size: 30)
          else if (iconOrAsset is String)
          // Render the transparent image
            Image.asset(
              iconOrAsset,
              width: 30,
              height: 30,
              // Note: We don't set color here so the image keeps its original colors
              fit: BoxFit.contain,
            ),

          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}