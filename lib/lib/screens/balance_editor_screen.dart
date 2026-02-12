// File: lib/screens/balance_editor_screen.dart
import 'package:flutter/material.dart';
import '../user_data.dart';

class BalanceEditorScreen extends StatefulWidget {
  const BalanceEditorScreen({super.key});

  @override
  State<BalanceEditorScreen> createState() => _BalanceEditorScreenState();
}

class _BalanceEditorScreenState extends State<BalanceEditorScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Show current balance in the text field
    _controller.text = UserData.balance.value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Balance"),
        backgroundColor: const Color(0xFF00AA4F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Enter new balance amount:"),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixText: "Rs. ",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00AA4F),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                double? newAmount = double.tryParse(_controller.text);
                if (newAmount != null) {
                  UserData.setBalance(newAmount);
                  Navigator.pop(context); // Go back to Main Screen
                }
              },
              child: const Text("Save New Balance"),
            )
          ],
        ),
      ),
    );
  }
}