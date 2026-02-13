// File: lib/amount_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'review_screen.dart';
import 'amount_experiments.dart';

class AmountScreen extends StatefulWidget {
  final String contactName;
  final String contactNumber;
  final String? contactImage;
  final String? contactInitials;

  const AmountScreen({
    super.key,
    required this.contactName,
    required this.contactNumber,
    this.contactImage,
    this.contactInitials,
  });

  @override
  State<AmountScreen> createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  String amountText = "";
  final _amountController = TextEditingController();
  final _formatter = NumberFormat('#,##0');

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_formatAmount);
  }

  @override
  void dispose() {
    _amountController.removeListener(_formatAmount);
    _amountController.dispose();
    super.dispose();
  }

  void _formatAmount() {
    final originalText = _amountController.text;
    final unformattedText = originalText.replaceAll(',', '');

    // Prevent infinite loop by checking if the base number has changed
    if (unformattedText == amountText) return;

    amountText = unformattedText;

    final double? numericValue = double.tryParse(unformattedText);
    if (numericValue != null) {
      final String formattedText = _formatter.format(numericValue);
      if (formattedText != originalText) {
        _amountController.value = _amountController.value.copyWith(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      }
    } else if (unformattedText.isEmpty && originalText.isNotEmpty) {
      _amountController.clear();
    }
    
    // Update UI based on validity
    setState(() {});
  }


  bool get isValid {
    if (amountText.isEmpty) return false;
    final double? val = double.tryParse(amountText);
    return val != null && val > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ======================================================
            // 1. TOP SECTION (Green Background)
            // ======================================================
            Container(
              width: double.infinity,
              color: AmountExperiments.headerBgColor,
              padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom App Bar Row
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          "easypaisa Transfer",
                          style: AmountExperiments.headerTitle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Empty SizedBox to balance the Back Button so title stays centered
                      const SizedBox(width: 48),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.only(top: 25.0, left: 10.0, bottom: 15.0),
                    child: Text(
                      "Sending to easypaisa account",
                      style: AmountExperiments.headerSubtitle,
                    ),
                  ),

                  // Recipient Info
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: AmountExperiments.receiverAvatarSize,
                          height: AmountExperiments.receiverAvatarSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: AmountExperiments.avatarBorderColor,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            widget.contactInitials ?? widget.contactName[0],
                            style: AmountExperiments.receiverInitialsStyle,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Name and Number
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.contactName, style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                            Text(widget.contactNumber, style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            // ======================================================
            // 2. BOTTOM SECTION (White Background)
            // ======================================================
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Enter Amount", style: AmountExperiments.enterAmountLabel),

                  const SizedBox(height: 5),

                  // Amount Input
                  Align(
                    alignment: const Alignment(-0.1, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, left: 0),
                          child: const Text(
                              AmountExperiments.currencySymbol,
                              style: AmountExperiments.currencyStyle
                          ),
                        ),
                        const SizedBox(width: 2),

                        IntrinsicWidth(
                          child: TextField(
                            controller: _amountController,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            showCursor: false, // <--- NO BLINKING CURSOR
                            style: AmountExperiments.inputAmountStyle,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "0",
                              hintStyle: TextStyle(color: Colors.black, fontSize: 40),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // "Add a Message" Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(Icons.add_circle_outline, color: Colors.black87, size: 20),
                      SizedBox(width: 8),
                      Text("Add a Message Here (Optional)", style: AmountExperiments.addMessageTextStyle),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // ======================================================
                  // 3. NEXT BUTTON (Bottom)
                  // ======================================================
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isValid
                              ? AmountExperiments.activeBtnColor
                              : AmountExperiments.inactiveBtnColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                        ),
                        onPressed: isValid ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewScreen(
                                contactName: widget.contactName,
                                contactNumber: widget.contactNumber,
                                amount: amountText,
                              ),
                            ),
                          );
                        } : null,
                        child: const Text("NEXT", style: AmountExperiments.btnTextStyle),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Keyboard safety padding
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 10),
          ],
        ),
      ),
    );
  }
}
