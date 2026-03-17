import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'user_data.dart';

class QrReceiptScreen extends StatefulWidget {
  final String amount;
  final String storeName;
  final bool isSpecialQr;
  final DateTime? dateTime;

  const QrReceiptScreen({
    super.key,
    required this.amount,
    required this.storeName,
    this.isSpecialQr = false,
    this.dateTime,
  });

  @override
  State<QrReceiptScreen> createState() => _QrReceiptScreenState();
}

class _QrReceiptScreenState extends State<QrReceiptScreen> {
  late final String _transactionID;

  @override
  void initState() {
    super.initState();
    // Use the same deterministic ID for the same transaction time if possible,
    // otherwise generate a random one as before.
    if (widget.dateTime != null) {
      final random = Random(widget.dateTime!.millisecondsSinceEpoch);
      _transactionID = "ID#${random.nextInt(90000000) + 4300000000}";
    } else {
      _transactionID = "ID#${Random().nextInt(90000000) + 4300000000}";
    }
  }

  String get _displayDate {
    final date = widget.dateTime ?? DateTime.now();
    // Format changed to: 14 March 2026
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    final String datePart = formatter.format(date);
    return "$datePart  ${_formatTime(date)}";
  }

  String _formatTime(DateTime date) {
    int hour = date.hour;
    String amPm = hour >= 12 ? "PM" : "AM";
    
    // Convert to 12-hour format
    hour = hour % 12;
    if (hour == 0) hour = 12; // 0 becomes 12 for 12 AM/PM
    
    return "${hour}:${date.minute.toString().padLeft(2, '0')} $amPm";
  }

  String _formatAmountWithCommas(String amount) {
    try {
      // Keeping your safer parsing logic
      final number = int.parse(amount.replaceAll(',', ''));
      final formatter = NumberFormat('#,###');
      return formatter.format(number);
    } catch (e) {
      return amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;

    // ===============================================================
    // --- STYLE CONSTANTS (COPIED EXACTLY FROM DESIRED LOOK) ---
    // ===============================================================
    const Color headingColor = Color(0xFF505050);

    const double headerTextVerticalShift = -22.0;
    const double headerTextHorizontalShift = 0.0;
    const double spaceBetweenTickAndText = 0.0;
    const double spaceBetweenTextLines = 0.0;

    const double headingFontSize = 16.0;
    const double subTextFontSize = 15.0;

    const double spaceBeforeAmountField = 4.0;
    const double gapBeforeFeeField = 4.0;

    const double totalLabelFontSize = 16.0;
    const double totalSectionVerticalShift = -10.0;

    // ---------------------------------------------------------------
    // Desired look dimensions
    const double receiptHeightFactor = 0.75;
    const double receiptBottomOffset = 130.0;
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
                    clipper: ReceiptClipper(), // Using the local clipper
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

                                        // --- EASYPAISA LOGO ---
                                        Image.asset(
                                          'assets/re_ep.jpg',
                                          height: 30,
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
                                          child: Text(
                                            widget.isSpecialQr 
                                                ? "Your easypaisa QR payment has been made" 
                                                : "Your RAAST QR payment has been made",
                                            style: const TextStyle(color: Colors.black54, fontSize: 11),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // 2. The Close Button
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).popUntil((route) => route.isFirst);
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

                                  const Spacer(flex: 3),

                                  // FIELD 1: STORE NAME
                                  _buildCleanField(
                                      "Store Name",
                                      widget.storeName,
                                      headingColor: headingColor,
                                      headingFontSize: headingFontSize,
                                      subTextFontSize: subTextFontSize,
                                      headingSubTextSpacing: headingSubTextSpacing,
                                      subTextLetterSpacing: subTextLetterSpacing
                                  ),

                                  const SizedBox(height: 10),

                                  // FIELD 2: PAID BY (DYNAMIC LOGIC KEPT INTACT)
                                  ValueListenableBuilder<String>(
                                    valueListenable: UserData.userName,
                                    builder: (context, name, _) => ValueListenableBuilder<String>(
                                      valueListenable: UserData.userNumber,
                                      builder: (context, number, _) => _buildCleanField(
                                          "Paid by",
                                          name,
                                          subValue: number,
                                          subValueTopPadding: 0.0,
                                          headingColor: headingColor,
                                          headingFontSize: headingFontSize,
                                          subTextFontSize: subTextFontSize,
                                          headingSubTextSpacing: headingSubTextSpacing,
                                          subTextLetterSpacing: subTextLetterSpacing
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: spaceBeforeAmountField),

                                  // FIELD 3: AMOUNT
                                  _buildCleanField(
                                      "Amount",
                                      "${_formatAmountWithCommas(widget.amount)}.00",
                                      headingColor: headingColor,
                                      headingFontSize: headingFontSize,
                                      subTextFontSize: subTextFontSize,
                                      headingSubTextSpacing: headingSubTextSpacing,
                                      subTextLetterSpacing: subTextLetterSpacing
                                  ),

                                  SizedBox(height: gapBeforeFeeField),

                                  // FIELD 4: FEE
                                  _buildCleanField(
                                      "Fee / Charge",
                                      "No Charge",
                                      headingColor: headingColor,
                                      headingFontSize: headingFontSize,
                                      subTextFontSize: subTextFontSize,
                                      headingSubTextSpacing: headingSubTextSpacing,
                                      subTextLetterSpacing: subTextLetterSpacing
                                  ),

                                  const Spacer(flex: 4),

                                  // TOTAL SECTION (Styled to match the requested look)
                                  Transform.translate(
                                    offset: Offset(0, totalSectionVerticalShift),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Total Amount",
                                            style: TextStyle(
                                                color: const Color(0xFF00C853),
                                                fontSize: totalLabelFontSize,
                                                fontWeight: FontWeight.bold
                                            )
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                            "Rs. ${_formatAmountWithCommas(widget.amount)}.00",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.normal
                                            )
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Spacer(flex: 5),

                                  // FOOTER IMAGE
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 2.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Transform.translate(
                                          offset: const Offset(10, -8),
                                          child: Image.asset(
                                            'assets/reciept_2.jpg',
                                            height: 31,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
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
}

class ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double bumpWidth = 4.0;
    double gapWidth = 5.0;
    double toothHeight = 1.5;
    path.moveTo(0, toothHeight);
    double x = 0;
    while (x < size.width) {
      path.relativeQuadraticBezierTo(bumpWidth / 2, -toothHeight * 2, bumpWidth, 0);
      x += bumpWidth;

      if (x >= size.width) break;
      path.relativeLineTo(gapWidth, 0);
      x += gapWidth;
    }
    path.lineTo(size.width, toothHeight);
    path.lineTo(size.width, size.height - toothHeight);
    x = size.width;
    while (x > 0) {
      path.relativeQuadraticBezierTo(-bumpWidth / 2, toothHeight * 2, -bumpWidth, 0);
      x -= bumpWidth;

      if (x <= 0) break;
      path.relativeLineTo(-gapWidth, 0);
      x -= gapWidth;
    }
    path.lineTo(0, toothHeight);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
