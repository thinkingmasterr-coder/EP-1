// File: lib/lib/till_payment_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'till_processing_screen.dart';

class TillPaymentScreen extends StatefulWidget {
  const TillPaymentScreen({super.key});

  @override
  State<TillPaymentScreen> createState() => _TillPaymentScreenState();
}

class _TillPaymentScreenState extends State<TillPaymentScreen> {
  final TextEditingController _tillController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00C853),
        centerTitle: true,
        title: Text(
          'Payments',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 17,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- 1. NO FAVOURITES YET ---
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // [CHANGED] Stack: Yellow Filled Star + White Plus Sign
                  Stack(
                    alignment: Alignment.center,
                    children: const [
                      Icon(Icons.star, color: Color(0xFFFDD835), size: 40),
                      Icon(Icons.add, color: Colors.white, size: 24),
                    ],
                  ),

                  const SizedBox(width: 16.0),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No Favourites Yet!',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          'The Favourites list can help you remember your favourite content.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- 2. TILL PAYMENT HEADER ---
            _buildGreenStripContainer(
              child: ListTile(
                leading: const Icon(Icons.receipt_long, color: Color(0xFF00C853)),
                title: const Text(
                  'Till Payment',
                  style: TextStyle(
                    color: Color(0xFF00C853),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                trailing: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF00C853),
                  size: 20,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // --- 3. TILL NUMBER INPUT ---
            _buildGreenStripContainer(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Till Number",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    TextField(
                      controller: _tillController,
                      decoration: const InputDecoration(
                        hintText: '4~9',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // --- 4. AMOUNT INPUT ---
            _buildGreenStripContainer(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Amount",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        hintText: '1~100000',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // --- 5. NEXT BUTTON ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_tillController.text.isNotEmpty && _amountController.text.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TillProcessingScreen(
                            tillNumber: _tillController.text,
                            amount: _amountController.text,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'NEXT',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreenStripContainer({required Widget child}) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5,
              color: const Color(0xFF00AA4F),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}