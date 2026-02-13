
// File: lib/screens/balance_editor_screen.dart
import 'package:flutter/material.dart';
import '../user_data.dart';
import '../recipient_experiments.dart';

class BalanceEditorScreen extends StatefulWidget {
  const BalanceEditorScreen({super.key});

  @override
  State<BalanceEditorScreen> createState() => _BalanceEditorScreenState();
}

class _BalanceEditorScreenState extends State<BalanceEditorScreen> {
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _recipientNameController = TextEditingController();
  final TextEditingController _recipientNumberController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Show current balance in the text field
    _balanceController.text = UserData.balance.value.toStringAsFixed(2);
  }

  void _addContact() {
    final String recipientName = _recipientNameController.text;
    final String recipientNumber = _recipientNumberController.text;
    // final String accountName = _accountNameController.text;
    // final String accountNumber = _accountNumberController.text;

    if (recipientName.isNotEmpty && recipientNumber.isNotEmpty) {
      setState(() {
        UserData.contacts.add({
          "name": recipientName,
          "number": recipientNumber,
          "initials": recipientName.isNotEmpty ? recipientName.substring(0, 1) : "",
        });
      });
      _recipientNameController.clear();
      _recipientNumberController.clear();
      _accountNameController.clear();
      _accountNumberController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contact Added!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Balance & Contacts"),
        backgroundColor: const Color(0xFF00AA4F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Balance Editor ---
            const Text("Enter new balance amount:"),
            const SizedBox(height: 10),
            TextField(
              controller: _balanceController,
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
                double? newAmount = double.tryParse(_balanceController.text);
                if (newAmount != null) {
                  UserData.setBalance(newAmount);
                  // Omit Navigator.pop(context) to keep screen open
                }
              },
              child: const Text("Save New Balance"),
            ),
            const Divider(height: 40),

            // --- Contact Adder ---
            const Text(
              "Add New Contact",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // --- Sent To Section ---
            const Text(
              "Sent To:",
              style: RecipientExperiments.instructionText,
            ),
            const SizedBox(height: 10),
            _buildTextField(_recipientNameController, "Recipient Name"),
            const SizedBox(height: 10),
            _buildTextField(_recipientNumberController, "Recipient Number", keyboardType: TextInputType.phone),
            const SizedBox(height: 20),

            // --- Account Details Section ---
            const Text(
              "Account Details:",
              style: RecipientExperiments.instructionText,
            ),
            const SizedBox(height: 10),
            _buildTextField(_accountNameController, "Account Holder Name"),
            const SizedBox(height: 10),
            _buildTextField(_accountNumberController, "Account Number", keyboardType: TextInputType.phone),
            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00AA4F),
                foregroundColor: Colors.white,
              ),
              onPressed: _addContact,
              child: const Text("Save Contact"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {TextInputType? keyboardType}) {
    return Container(
      height: RecipientExperiments.searchBarHeight,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: RecipientExperiments.searchBarBgColor,
        borderRadius: BorderRadius.circular(RecipientExperiments.searchBarRadius),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: RecipientExperiments.greenLineWidth,
            height: double.infinity,
            color: const Color(0xFF00AA4F),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textAlignVertical: TextAlignVertical.center,
              style: RecipientExperiments.inputTextStyle,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: RecipientExperiments.inputContentPadding,
                hintText: hintText,
                hintStyle: RecipientExperiments.hintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
