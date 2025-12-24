// File: lib/transfer_screen.dart
import 'package:flutter/material.dart';
import 'user_data.dart';
import 'amount_screen.dart';
import 'experiment_styles.dart'; // <--- WIRED TO YOUR LAB

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  String searchQuery = "";
  int _selectedToggleIndex = 0;

  void _goToAmountScreen(Map<String, String> contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AmountScreen(
          contactName: contact["name"]!,
          contactNumber: contact["number"]!,
          contactInitials: contact["initials"],
        ),
      ),
    );
  }

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
        title: const Text(
          "easypaisa Transfer",
          style: ExperimentStyles.appBarTitle, // <--- EXPERIMENT HERE
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- 1. TABS ---
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFF00AA4F), width: 3)),
                    ),
                    child: const Text(
                      "Send Money",
                      textAlign: TextAlign.center,
                      style: ExperimentStyles.tabSelected, // <--- EXPERIMENT HERE
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Text(
                      "History",
                      textAlign: TextAlign.center,
                      style: ExperimentStyles.tabUnselected, // <--- EXPERIMENT HERE
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // --- 2. TOGGLE SWITCH ---
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedToggleIndex = 0),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _selectedToggleIndex == 0 ? const Color(0xFF00AA4F) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: _selectedToggleIndex == 0 ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2)] : [],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Mobile No.",
                        style: _selectedToggleIndex == 0
                            ? ExperimentStyles.toggleSelected    // <--- EXPERIMENT HERE
                            : ExperimentStyles.toggleUnselected, // <--- EXPERIMENT HERE
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedToggleIndex = 1),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _selectedToggleIndex == 1 ? const Color(0xFF00AA4F) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: _selectedToggleIndex == 1 ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2)] : [],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Digital Account No",
                        style: _selectedToggleIndex == 1
                            ? ExperimentStyles.toggleSelected    // <--- EXPERIMENT HERE
                            : ExperimentStyles.toggleUnselected, // <--- EXPERIMENT HERE
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // --- 3. SEARCH BAR ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter Receiver's Mobile Number",
                  style: ExperimentStyles.inputLabel, // <--- EXPERIMENT HERE
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    keyboardType: TextInputType.number,
                    style: ExperimentStyles.inputText, // <--- EXPERIMENT HERE
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      border: InputBorder.none,
                      hintText: "Enter Receiver's Number or select from contacts",
                      hintStyle: ExperimentStyles.inputHint, // <--- EXPERIMENT HERE
                      suffixIcon: Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // --- 4. CONTACTS LIST ---
          Expanded(
            child: searchQuery.isEmpty
                ? const SizedBox()
                : ListView.builder(
              itemCount: UserData.contacts.length,
              itemBuilder: (context, index) {
                final contact = UserData.contacts[index];

                if (!contact["number"]!.contains(searchQuery) && !contact["name"]!.toLowerCase().contains(searchQuery.toLowerCase())) {
                  return const SizedBox.shrink();
                }

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFFE8F5E9),
                    child: Text(
                        contact["initials"]!,
                        style: ExperimentStyles.contactInitials // <--- EXPERIMENT HERE
                    ),
                  ),
                  title: Text(
                      contact["name"]!,
                      style: ExperimentStyles.contactName // <--- EXPERIMENT HERE
                  ),
                  subtitle: Text(
                      contact["number"]!,
                      style: ExperimentStyles.contactNumber // <--- EXPERIMENT HERE
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
                  onTap: () => _goToAmountScreen(contact),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}