import 'package:flutter/material.dart';
import 'review_screen.dart'; // Now this file exists!

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

  bool get isValid => amountText.isNotEmpty && double.tryParse(amountText) != null && double.parse(amountText) > 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Sending to easypaisa account", style: TextStyle(color: Colors.black, fontSize: 14)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: widget.contactInitials != null
              ? Text(widget.contactInitials!, style: const TextStyle(color: Color(0xFF00AA4F), fontSize: 20, fontWeight: FontWeight.bold))
              : null,
          ),
          const SizedBox(height: 10),
          Text(widget.contactName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(widget.contactNumber, style: const TextStyle(fontSize: 14, color: Colors.grey)),

          const SizedBox(height: 40),

          const Text("Enter Amount", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Rs. ", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 150,
                child: TextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "0",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onChanged: (value) {
                    setState(() {
                      amountText = value;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add_circle_outline, color: Colors.grey, size: 20),
              SizedBox(width: 5),
              Text("Add a Message Here (Optional)", style: TextStyle(color: Colors.grey)),
            ],
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isValid ? const Color(0xFF00AA4F) : Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                onPressed: isValid ? () {
                  // NAVIGATE TO REVIEW SCREEN
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
                child: const Text("Next", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 20),
        ],
      ),
    );
  }
}