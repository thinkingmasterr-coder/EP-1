import 'package:flutter/material.dart';
import 'package:easypaisa/qr_review_screen.dart';
import 'user_data.dart';

class QrResultScreen extends StatefulWidget {
  final String qrCode;

  const QrResultScreen({super.key, required this.qrCode});

  @override
  State<QrResultScreen> createState() => _QrResultScreenState();
}

class _QrResultScreenState extends State<QrResultScreen> {
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

  String _getStoreName() {
    if (UserData.isAutoQr.value) {
      return _extractNameFromQr(widget.qrCode);
    } else {
      return UserData.qrStoreName.value;
    }
  }

  String _extractNameFromQr(String qr) {
    // We collect all possible names here
    List<String> nameCandidates = [];

    try {
      int i = 0;
      while (i < qr.length - 4) {
        String tag = qr.substring(i, i + 2);
        int length = int.parse(qr.substring(i + 2, i + 4));
        String value = qr.substring(i + 4, i + 4 + length);

        // Standard Merchant Name (Tag 59)
        if (tag == "59") {
          nameCandidates.add(value.trim());
        }
        // Additional Data Field (Tag 62)
        else if (tag == "62") {
          int j = 0;
          while (j < value.length - 4) {
            String subTag = value.substring(j, j + 2);
            int subLength = int.parse(value.substring(j + 2, j + 4));
            String subValue = value.substring(j + 4, j + 4 + subLength);

            // EMVCo standard for Store/Terminal Label
            if (subTag == "03" || subTag == "07") {
              nameCandidates.add(subValue.trim());
            }
            // Proprietary format (Easypaisa/JazzCash)
            else if (subTag == "05") {
              List<String> parts = subValue.split('|');
              if (parts.isNotEmpty) {
                nameCandidates.add(parts.last.trim());
              }
            }
            j += 4 + subLength;
          }
        }

        i += 4 + length;
      }
    } catch (e) {
      debugPrint("QR Parse Error: $e");
    }

    // Sort all candidates by length (longest first)
    // This guarantees we get the uncut name and bypass short terminal IDs
    if (nameCandidates.isNotEmpty) {
      nameCandidates.sort((a, b) => b.length.compareTo(a.length));
      return nameCandidates.first;
    }

    // Fallback if absolutely nothing was found
    return UserData.qrStoreName.value;
  }

  @override
  Widget build(BuildContext context) {
    final String storeName = _getStoreName();

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
            Center(
              child: Column(
                children: [
                  Image.asset('assets/qr_code1.png', width: 150, height: 150),
                  const SizedBox(height: 10),
                  Text(
                    storeName,
                    style: const TextStyle(
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
                        hintText: 'Enter Amount',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
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
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
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
                        storeName: storeName,
                        isSpecialQr: false,
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