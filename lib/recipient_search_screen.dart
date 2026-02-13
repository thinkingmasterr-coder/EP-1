// File: lib/recipient_search_screen.dart
import 'package:flutter/material.dart';
import 'user_data.dart';
import 'amount_screen.dart';
import 'recipient_experiments.dart'; // <--- WIRED UP

class RecipientSearchScreen extends StatefulWidget {
  const RecipientSearchScreen({super.key});

  @override
  State<RecipientSearchScreen> createState() => _RecipientSearchScreenState();
}

class _RecipientSearchScreenState extends State<RecipientSearchScreen> {
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

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
    final filteredContacts = UserData.contacts.where((contact) {
      final number = contact["number"]!;
      final name = contact["name"]!.toLowerCase();
      final query = searchQuery.toLowerCase();
      return number.contains(query) || name.contains(query);
    }).toList();

    // Sort contacts by name (A-Z)
    filteredContacts.sort((a, b) => a['name']!.toLowerCase().compareTo(b['name']!.toLowerCase()));

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
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // --- 1. INSTRUCTION LABEL ---
          const Padding(
            padding: RecipientExperiments.instructionPadding,
            child: Text(
              "Enter Mobile Number or Contact Name",
              style: RecipientExperiments.instructionText,
            ),
          ),

          // --- 2. SEARCH INPUT FIELD ---
          Container(
            height: RecipientExperiments.searchBarHeight,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: RecipientExperiments.searchBarBgColor,
              borderRadius: BorderRadius.circular(RecipientExperiments.searchBarRadius),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                // A. Green Accent Line
                Container(
                  width: RecipientExperiments.greenLineWidth,
                  height: double.infinity,
                  color: const Color(0xFF00AA4F),
                ),

                // B. Input Field
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    onChanged: (value) => setState(() => searchQuery = value),
                    keyboardType: TextInputType.text,
                    // Use center alignment + contentPadding from experiment file
                    textAlignVertical: TextAlignVertical.center,
                    style: RecipientExperiments.inputTextStyle,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true, // Helps with strict vertical alignment
                      contentPadding: RecipientExperiments.inputContentPadding,
                      hintText: "Enter Number or Search Contacts",
                      hintStyle: RecipientExperiments.hintTextStyle,
                    ),
                  ),
                ),

                // C. Right Arrow Button
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00AA4F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // --- 3. CONTACTS HEADING (Grey Bar) ---
          Container(
            width: double.infinity,
            color: RecipientExperiments.headerBgColor,
            padding: RecipientExperiments.headerPadding,
            child: const Text(
              "Your easypaisa Contacts",
              style: RecipientExperiments.headerText,
            ),
          ),

          // --- 4. CONTACT LIST ---
          Expanded(
            child: ListView.separated(
              itemCount: filteredContacts.length,
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: Colors.black12, height: 1),
              ),
              itemBuilder: (context, index) {
                final contact = filteredContacts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: InkWell(
                    onTap: () => _goToAmountScreen(contact),
                    child: Row(
                      children: [
                        // Left: Avatar
                        Container(
                          width: RecipientExperiments.avatarSize,
                          height: RecipientExperiments.avatarSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF00AA4F), width: 1.5),
                            color: Colors.white,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            contact["initials"]!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        // Center: Name & Number
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contact["name"]!,
                                style: RecipientExperiments.contactName,
                              ),
                              const SizedBox(height: 1),
                              Text(
                                contact["number"]!,
                                style: RecipientExperiments.contactNumber,
                              ),
                            ],
                          ),
                        ),

                        // Right: easypaisa Logo
                        _buildEasyPaisaLogo(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEasyPaisaLogo() {
    return ClipOval(
      child: Image.asset(
        'assets/EP_logo.webp',
        width: 30,
        height: 30,
        fit: BoxFit.cover,
      ),
    );
  }
}
