// File: lib/receipt_screen.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'main.dart';

class ReceiptScreen extends StatefulWidget {
  final String amount;
  final String contactName;
  final String contactNumber;

  const ReceiptScreen({
    super.key,
    required this.amount,
    required this.contactName,
    required this.contactNumber,
  });

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  String get _transactionID => "ID#${Random().nextInt(90000000) + 4000000000}";

  String get _displayDate {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')} ${_getMonth(now.month)} ${now.year}  ${_formatTime(now)}";
  }

  String _getMonth(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }

  String _formatTime(DateTime date) {
    int hour = date.hour > 12 ? date.hour - 12 : date.hour;
    String amPm = date.hour >= 12 ? "PM" : "AM";
    return "${hour}:${date.minute.toString().padLeft(2, '0')} $amPm";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A3A48), // Dark background
      body: SafeArea(
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 1.0, end: 0.0), // Animates from Offset(0,1) to (0,0)
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack, // Adds a slight bounce effect
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value * MediaQuery.of(context).size.height), // Slide up from bottom
                child: child,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85, // Prevents overflow on small screens
                ),
                child: ClipPath(
                  clipper: ReceiptClipper(),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // HEADER (Fixed, doesn't scroll)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const EasypaisaApp()),
                                      (route) => false,
                                );
                              },
                              child: const Icon(Icons.close, color: Colors.black54, size: 24),
                            ),
                          ),
                        ),

                        // SCROLLABLE CONTENT
                        Flexible(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Column(
                              children: [
                                // --- LOGO & SUCCESS ---
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF00C853), // Vivid Green
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check, color: Colors.white, size: 40),
                                ),
                                const SizedBox(height: 15),

                                // Logo Placeholder
                                const Text("easypaisa", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: -1)),

                                const SizedBox(height: 10),
                                const Text(
                                  "Transaction Successful",
                                  style: TextStyle(
                                      color: Color(0xFF00C853),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  "Money has been sent",
                                  style: TextStyle(color: Colors.grey, fontSize: 14),
                                ),

                                const SizedBox(height: 25),

                                // --- METADATA ---
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_displayDate, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                      const SizedBox(height: 4),
                                      Text(_transactionID, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // --- DETAILS LIST ---
                                Row(
                                  children: [
                                    const Icon(Icons.account_balance_wallet_outlined, color: Colors.grey, size: 20),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text("Funding Source", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 2),
                                        Text("easypaisa Account", style: TextStyle(color: Colors.black, fontSize: 14)),
                                      ],
                                    )
                                  ],
                                ),

                                const SizedBox(height: 15),

                                _buildCleanField("Sent to", widget.contactName, subValue: widget.contactNumber),
                                _buildCleanField("Account Details", "Shahana Amaan"),
                                _buildCleanField("Sent by", "FATIMA SHAH", subValue: "03025529918"),
                                _buildCleanField("Amount", widget.amount),
                                _buildCleanField("Fee / Charge", "No Charge"),

                                const SizedBox(height: 10),

                                // Total Section
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Total Amount", style: TextStyle(color: Color(0xFF00C853), fontSize: 16, fontWeight: FontWeight.bold)),
                                    Text("Rs. ${widget.amount}.00", style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal)),
                                  ],
                                ),

                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),

                        // FOOTER (Fixed at bottom of receipt card)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildActionItem(Icons.share_outlined, "Share"),
                              _buildActionItem(Icons.image_outlined, "Save to Gallery"),
                              _buildActionItem(Icons.picture_as_pdf_outlined, "Save as PDF"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCleanField(String label, String value, {String? subValue}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(color: Colors.black, fontSize: 15)),
                if (subValue != null)
                  Text(subValue, style: const TextStyle(color: Colors.black, fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.black54, size: 24),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

class ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);

    // Bottom Zig Zag
    double x = 0;
    double y = size.height;
    double increment = 10;

    while (x < size.width) {
      x += increment;
      y = (y == size.height) ? size.height - 8 : size.height;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}