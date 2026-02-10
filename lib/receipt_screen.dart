// File: lib/receipt_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'main.dart';
// -------------------------------------------------------------------------
// NOTE: You MUST add 'google_fonts' to your pubspec.yaml for the 'a' change.
// dependencies:
//   google_fonts: ^6.1.0
// -------------------------------------------------------------------------
import 'package:google_fonts/google_fonts.dart';

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
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;

    // ===============================================================
    // --- MANUAL CONTROLS FOR RECEIPT ---
    // ===============================================================

    // [CONTROL 0] COLORS
    const Color headingColor = Color(0xFF505050);

    // [CONTROL 1 & 2] HEADER TEXT POSITION
    const double headerTextVerticalShift = -22.0;
    const double headerTextHorizontalShift = 0.0;

    // [CONTROL 3] HEADER SPACING
    const double spaceBetweenTickAndText = 0.0;
    const double spaceBetweenTextLines = 0.0;

    // [CONTROL 4] GENERAL FONT SIZES
    const double headingFontSize = 16.0;
    const double subTextFontSize = 15.0;

    // [CONTROL 5] SENT BY NUMBER ADJUSTMENT
    const double sentByNumberTopPadding = 0.0;

    // [CONTROL 6] AMOUNT SECTION VERTICAL SHIFT
    const double spaceBeforeAmountField = 4.0;

    // [CONTROL 7] FEE / CHARGE VERTICAL SHIFT
    const double gapBeforeFeeField = 4.0;

    // [CONTROL 8] TOTAL SECTION
    const double totalLabelFontSize = 16.0;
    const double totalSectionVerticalShift = -10.0;

    // [CONTROL 9] FOOTER ICONS
    const double footerIconScale = 0.85;

    // [CONTROL 10] GREEN DOT POSITION
    const double greenDotX = 30.5;
    const double greenDotY = -8.8;

    // [CONTROL 11] GREEN DOT SIZE
    const double greenDotSize = 5.5;

    // [CONTROL 12] WALLET IMAGE SIZE
    // Adjust this if the image looks too big or small compared to the text
    const double walletImageSize = 30.0;

    // ---------------------------------------------------------------
    const double receiptHeightFactor = 0.90;
    const double receiptBottomOffset = 20.0;
    const double receiptHorizontalMargin = 13.0;
    const double tickMarkContainerSize = 35.0;
    const double tickIconSize = 25.0;
    const double easypaisaFontSize = 25.0;
    const double transactionSuccessfulFontSize = 26.0;
    const double headingSubTextSpacing = 0.5;
    const double subTextLetterSpacing = -0.6;
    // ===============================================================

    final double calculatedHeight = screenHeight * receiptHeightFactor;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Container(
        color: Colors.black,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFF3A3A48), // Dark background
            body: Align(
              alignment: Alignment.bottomCenter,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: 0.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, value * screenHeight),
                    child: child,
                  );
                },
                child: Container(
                  height: calculatedHeight,
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    bottom: receiptBottomOffset,
                    left: receiptHorizontalMargin,
                    right: receiptHorizontalMargin,
                  ),
                  child: ClipPath(
                    clipper: ReceiptClipper(),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          // --- HEADER (Gray Section) ---
                          Container(
                            width: double.infinity,
                            color: const Color(0xFFF8F8F8),
                            padding: const EdgeInsets.fromLTRB(20, 38, 20, 0),
                            child: Stack(
                              children: [
                                // 1. The Main Content (Centered)
                                Align(
                                  alignment: Alignment.center,
                                  child: Transform.translate(
                                    offset: const Offset(headerTextHorizontalShift, headerTextVerticalShift),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: tickMarkContainerSize,
                                          width: tickMarkContainerSize,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF00C853),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.check, color: Colors.white, size: tickIconSize),
                                        ),
                                        SizedBox(height: spaceBetweenTickAndText),

                                        // --- EASYPAISA LOGO TEXT WITH GREEN DOT TRICK ---
                                        Stack(
                                          alignment: Alignment.center,
                                          clipBehavior: Clip.none,
                                          children: [
                                            Text(
                                              "easypaisa",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: easypaisaFontSize,
                                                letterSpacing: -1,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Transform.translate(
                                              offset: const Offset(greenDotX, greenDotY),
                                              child: Container(
                                                height: greenDotSize,
                                                width: greenDotSize,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF00C853),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: spaceBetweenTextLines),

                                        Text(
                                          "Transaction Successful",
                                          style: TextStyle(
                                              color: const Color(0xFF00C853),
                                              fontSize: transactionSuccessfulFontSize,
                                              fontWeight: FontWeight.bold
                                          ),
                                          textAlign: TextAlign.center,
                                        ),

                                        SizedBox(height: spaceBetweenTextLines),

                                        Transform.translate(
                                          offset: const Offset(0.0, -4.0),
                                          child: const Text(
                                            "Money has been sent",
                                            style: TextStyle(color: Colors.black54, fontSize: 11),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // 2. The Close Button (Top Right Overlay)
                                Positioned(
                                  right: 0,
                                  top: 0,
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
                              ],
                            ),
                          ),

                          // --- BODY (White Section) ---
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Metadata
                                  const SizedBox(height: 1),
                                  Text(_displayDate, style: const TextStyle(color: Colors.black54, fontSize: 11)),
                                  const SizedBox(height: 0),
                                  Transform.translate(
                                      offset: const Offset(0, -2.0),
                                      child: Text(_transactionID, style: const TextStyle(color: Colors.black54, fontSize: 11))
                                  ),

                                  const Spacer(flex: 2), // Flexible Space

                                  // Funding Source
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Transform.translate(
                                        offset: const Offset(0, 2.0),
                                        child: Text("Funding Source", style: TextStyle(color: headingColor, fontSize: headingFontSize, fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(height: headingSubTextSpacing),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // --- REPLACED ICON WITH ASSET IMAGE ---
                                          Image.asset(
                                            'assets/wallet_ik.png',
                                            width: walletImageSize,
                                            height: walletImageSize,
                                            fit: BoxFit.contain,
                                          ),
                                          const SizedBox(width: 4),
                                          Text("easypaisa Account", style: TextStyle(color: Colors.black54, fontSize: subTextFontSize, letterSpacing: subTextLetterSpacing)),
                                        ],
                                      ),
                                    ],
                                  ),

                                  const Spacer(flex: 3), // Flexible Space

                                  // Fields
                                  _buildCleanField("Sent to", widget.contactName, subValue: widget.contactNumber, headingColor: headingColor, headingFontSize: headingFontSize, subTextFontSize: subTextFontSize, headingSubTextSpacing: headingSubTextSpacing, subTextLetterSpacing: subTextLetterSpacing),
                                  const SizedBox(height: 10),
                                  _buildCleanField("Account Details", "Shahana Amaan", headingColor: headingColor, headingFontSize: headingFontSize, subTextFontSize: subTextFontSize, headingSubTextSpacing: headingSubTextSpacing, subTextLetterSpacing: subTextLetterSpacing),
                                  const SizedBox(height: 10),

                                  // SENT BY FIELD
                                  _buildCleanField(
                                      "Sent by",
                                      "FATIMA SHAH",
                                      subValue: "03025529918",
                                      subValueTopPadding: sentByNumberTopPadding,
                                      headingColor: headingColor,
                                      headingFontSize: headingFontSize,
                                      subTextFontSize: subTextFontSize,
                                      headingSubTextSpacing: headingSubTextSpacing,
                                      subTextLetterSpacing: subTextLetterSpacing
                                  ),

                                  SizedBox(height: spaceBeforeAmountField),

                                  _buildCleanField("Amount", "${widget.amount}.00", headingColor: headingColor, headingFontSize: headingFontSize, subTextFontSize: subTextFontSize, headingSubTextSpacing: headingSubTextSpacing, subTextLetterSpacing: subTextLetterSpacing),

                                  SizedBox(height: gapBeforeFeeField),

                                  _buildCleanField("Fee / Charge", "No Charge", headingColor: headingColor, headingFontSize: headingFontSize, subTextFontSize: subTextFontSize, headingSubTextSpacing: headingSubTextSpacing, subTextLetterSpacing: subTextLetterSpacing),

                                  const Spacer(flex: 4), // Flexible Space

                                  // Total Section
                                  Transform.translate(
                                    offset: Offset(0, totalSectionVerticalShift),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start, // Stacked on Left
                                      children: [
                                        Text(
                                            "Total Amount",
                                            style: TextStyle(
                                                color: const Color(0xFF00C853),
                                                fontSize: totalLabelFontSize,
                                                fontWeight: FontWeight.bold
                                            )
                                        ),
                                        const SizedBox(height: 2), // Small gap between label and amount
                                        Text(
                                            "Rs. ${widget.amount}.00",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.normal
                                            )
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Spacer(flex: 5), // Flexible Space

                                  // Footer Icons
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        _buildActionItem(Icons.share_outlined, "Share", scale: footerIconScale),
                                        const SizedBox(width: 25),
                                        _buildActionItem(Icons.image_outlined, "Save to Gallery", scale: footerIconScale),
                                        const SizedBox(width: 25),
                                        _buildActionItem(Icons.picture_as_pdf_outlined, "Save as PDF", scale: footerIconScale),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
      ),
    );
  }

  Widget _buildCleanField(String label, String value, {String? subValue, double subValueTopPadding = 2.0, required Color headingColor, required double headingFontSize, required double subTextFontSize, required double headingSubTextSpacing, required double subTextLetterSpacing}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: headingColor, fontSize: headingFontSize, fontWeight: FontWeight.bold)),
              SizedBox(height: headingSubTextSpacing),
              Transform.translate(
                offset: Offset(0.0, (label == "Fee / Charge") ? -4.0 : 0.0),
                child: Text(value, style: TextStyle(color: Colors.black54, fontSize: subTextFontSize, letterSpacing: subTextLetterSpacing)),
              ),
              if (subValue != null)
                Padding(
                  padding: EdgeInsets.only(top: subValueTopPadding),
                  child: Text(subValue, style: TextStyle(color: Colors.black54, fontSize: subTextFontSize, letterSpacing: subTextLetterSpacing)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label, {double scale = 1.0}) {
    // Applying scale to both icon and text
    return Column(
      children: [
        Icon(icon, color: Colors.black54, size: 22 * scale),
        SizedBox(height: 6 * scale),
        Text(label, style: TextStyle(fontSize: 10 * scale, color: Colors.grey)),
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
