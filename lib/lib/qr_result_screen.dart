import 'package:flutter/material.dart';
import 'package:easypaisa_clone/qr_review_screen.dart';
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

  // The special QR code string
  static const String specialQrCode = "0002010102112876003213bb98ea283b452b9d979bf570fc49ed0108TMICFBPK0224PK50TMFB00000000118677755204539953035865802PK5915ZAHID COLD DRIN6009Charsadda64380002EN0115ZAHID COLD DRIN0209Charsadda62520528OPS1|38563|ZAHID COLD DRINKS030712013180805Other6304B41D";

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
    // Logic to determine display name
    final bool isSpecialQr = widget.qrCode == specialQrCode;

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
                  isSpecialQr 
                    ? const Text(
                        "ZAHID COLD DRINKS",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    : ValueListenableBuilder<String>(
                        valueListenable: UserData.qrStoreName,
                        builder: (context, name, _) => Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
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
                        storeName: isSpecialQr ? "ZAHID COLD DRINKS" : UserData.qrStoreName.value,
                        isSpecialQr: isSpecialQr,
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
