import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      appBar: AppBar(
        backgroundColor: const Color(0xFF00C853),
        title: Text(
          'Payments',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: const Color(0xFFF1F1F1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // No Favourites Yet
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
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
                  const Icon(Icons.star_border, color: Color(0xFFFDD835), size: 40),
                  const SizedBox(width: 16.0),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No Favourites Yet!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
            const SizedBox(height: 20),

            // Till Payment Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.receipt_long, color: Color(0xFF00C853)),
                    title: const Text('Till Payment'),
                    trailing: const Icon(Icons.check_circle, color: Color(0xFF00C853)),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      controller: _tillController,
                      decoration: const InputDecoration(
                        labelText: 'Till Number',
                        hintText: '4-9',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        hintText: '1-100000',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement navigation to the next screen (e.g., confirmation/receipt)
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
          ],
        ),
      ),
    );
  }
}
