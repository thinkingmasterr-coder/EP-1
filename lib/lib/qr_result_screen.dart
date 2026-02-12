import 'package:flutter/material.dart';
import 'package:easypaisa_clone/qr_review_screen.dart';

class QrResultScreen extends StatefulWidget {
  final String qrCode;

  const QrResultScreen({super.key, required this.qrCode});

  @override
  State<QrResultScreen> createState() => _QrResultScreenState();
}

class _QrResultScreenState extends State<QrResultScreen> {
  // CHANGE 1: Removed text: '1020', now it starts empty
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  int _messageLength = 0;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        _messageLength = _messageController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _messageController.dispose();
    super.dispose();
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
          'QR Payment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Help', style: TextStyle(color: Colors.black)),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CHANGE 2: Made image smaller (100x100) and added text below
            Center(
              child: Column(
                children: [
                  Image.asset('assets/qr_code1.png', width: 150, height: 150),
                  const SizedBox(height: 10),
                  const Text(
                    'AK MOBILE CENTRE CHD',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Bill Amount',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 50,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    color: const Color(0xFF00AA4F),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Message (Optional)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$_messageLength/100',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 50,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    color: const Color(0xFF00AA4F),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      maxLength: 100,
                      decoration: const InputDecoration(
                        counterText: '',
                        hintText: 'Enter message here',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QrReviewScreen(
                        amount: _amountController.text,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
