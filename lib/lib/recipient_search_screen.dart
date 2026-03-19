// File: lib/recipient_search_screen.dart
import 'package:flutter/material.dart';
import 'user_data.dart';
import 'amount_screen.dart';
import 'recipient_experiments.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipientSearchScreen extends StatefulWidget {
  const RecipientSearchScreen({super.key});

  @override
  State<RecipientSearchScreen> createState() => _RecipientSearchScreenState();
}

class _RecipientSearchScreenState extends State<RecipientSearchScreen> {
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  void _goToAmountScreen(Map<String, String> contact, {String? fetchedAccountTitle}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AmountScreen(
          contactName: contact["name"]!,
          contactNumber: contact["number"]!,
          contactInitials: contact["initials"],
          fetchedAccountTitle: fetchedAccountTitle,
        ),
      ),
    );
  }

  Widget _buildSelectRow(String number) {
    return InkWell(
      onTap: () async {
        // Step A: Show a non-dismissible showDialog containing a CircularProgressIndicator.
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(
              color: RecipientExperiments.primaryGreen,
            ),
          ),
        );

        String? fetchedTitle;
        try {
          // Step B: Await an http.post request with 15 second timeout
          final response = await http.post(
            Uri.parse('http://192.168.100.9:5000/get_title'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'phone_number': number}),
          ).timeout(const Duration(seconds: 15));

          // Step C: If the status is 200, decode the JSON and extract the title string.
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data['title'] != null && data['title'].toString().isNotEmpty) {
              fetchedTitle = data['title'];
            }
          }
        } catch (e) {
          debugPrint("Title fetch error: $e");
        }

        // Step D: Pop the loading dialog
        if (mounted) {
          Navigator.of(context).pop();

          // Step E: Navigate ONLY if a title was successfully fetched.
          // If no title was fetched, it remains on the same page as requested.
          if (fetchedTitle != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AmountScreen(
                  contactName: fetchedTitle!,
                  contactNumber: number,
                  contactInitials: fetchedTitle!.isNotEmpty ? fetchedTitle![0].toUpperCase() : "U",
                ),
              ),
            );
          }
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                const SizedBox(
                  width: RecipientExperiments.avatarSize,
                  height: RecipientExperiments.avatarSize,
                  child: Center(
                    child: Text(
                      "Select",
                      style: TextStyle(
                        color: RecipientExperiments.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    number,
                    style: RecipientExperiments.contactName,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: Colors.black12, height: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedText(String text, String query, TextStyle style) {
    if (query.isEmpty) {
      return Text(text, style: style);
    }

    final lowerCaseText = text.toLowerCase();
    final lowerCaseQuery = query.toLowerCase();
    final startIndex = lowerCaseText.indexOf(lowerCaseQuery);

    if (startIndex == -1) {
      return Text(text, style: style);
    }

    final endIndex = startIndex + query.length;

    final before = text.substring(0, startIndex);
    final highlighted = text.substring(startIndex, endIndex);
    final after = text.substring(endIndex);

    return RichText(
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: before),
          TextSpan(
            text: highlighted,
            style: style.copyWith(backgroundColor: Colors.yellow),
          ),
          TextSpan(text: after),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Map<String, String>>>(
      valueListenable: UserData.contacts,
      builder: (context, allContacts, child) {
        final filteredContacts = allContacts.where((contact) {
          final number = contact["number"]!;
          final name = contact["name"]!.toLowerCase();
          final query = searchQuery.toLowerCase();
          return number.contains(query) || name.contains(query);
        }).toList();

        filteredContacts.sort((a, b) => a['name']!.toLowerCase().compareTo(b['name']!.toLowerCase()));

        final bool isNumeric = RegExp(r'^\d+$').hasMatch(searchQuery);
        final bool is11Digits = searchQuery.length == 11 && isNumeric;

        String headerText = "Your easypaisa Contacts";
        bool showHeader = true;

        if (searchQuery.isNotEmpty) {
          if (is11Digits) {
            showHeader = false;
          } else if (isNumeric) {
            headerText = "Contact not found";
          } else if (filteredContacts.isEmpty) {
            headerText = "Contact not found";
          }
        }

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
              const Padding(
                padding: RecipientExperiments.instructionPadding,
                child: Text(
                  "Enter Mobile Number or Contact Name",
                  style: RecipientExperiments.instructionText,
                ),
              ),
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
                    Container(
                      width: RecipientExperiments.greenLineWidth,
                      height: double.infinity,
                      color: RecipientExperiments.primaryGreen,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: (value) => setState(() => searchQuery = value),
                        keyboardType: TextInputType.text,
                        textAlignVertical: TextAlignVertical.center,
                        style: RecipientExperiments.inputTextStyle,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: RecipientExperiments.inputContentPadding,
                          hintText: "Enter Number or Search Contacts",
                          hintStyle: RecipientExperiments.hintTextStyle,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: RecipientExperiments.primaryGreen,
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
              if (showHeader)
                Container(
                  width: double.infinity,
                  color: RecipientExperiments.headerBgColor,
                  padding: RecipientExperiments.headerPadding,
                  child: Text(
                    headerText,
                    style: RecipientExperiments.headerText,
                  ),
                ),
              if (is11Digits) _buildSelectRow(searchQuery),
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
                            Container(
                              width: RecipientExperiments.avatarSize,
                              height: RecipientExperiments.avatarSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: RecipientExperiments.primaryGreen, width: 1.5),
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildHighlightedText(
                                    contact["name"]!,
                                    searchQuery,
                                    RecipientExperiments.contactName,
                                  ),
                                  const SizedBox(height: 1),
                                  _buildHighlightedText(
                                    contact["number"]!,
                                    searchQuery,
                                    RecipientExperiments.contactNumber,
                                  ),
                                ],
                              ),
                            ),
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
      },
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
