
// File: lib/transfer_screen.dart
import 'package:flutter/material.dart';
import 'user_data.dart';
import 'amount_screen.dart';
import 'experiment_styles.dart';
import 'recipient_search_screen.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  int _selectedToggleIndex = 0;
  String _inputLabel = "Enter Receiver's Mobile Number";

  void _handleToggle(int index) {
    setState(() {
      _selectedToggleIndex = index;
      if (index == 0) {
        _inputLabel = "Enter Receiver's Mobile Number";
      } else {
        _inputLabel = "Enter Receiver's Digital Account Number";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed background color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "easypaisa Transfer",
          style: ExperimentStyles.appBarTitle,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Help",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // --- 1. TABS ---
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1.0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFF00AA4F), width: 4.0)), // Made border thicker
                    ),
                    child: const Text(
                      "Send Money",
                      textAlign: TextAlign.center,
                      style: ExperimentStyles.tabSelected,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Text(
                      "History",
                      textAlign: TextAlign.center,
                      style: TextStyle( // Applied local style
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // --- 2. MY EASYPAISA FAVOURITES ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "My Easypaisa Favourites",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "See All",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 50), // Increased space

          // --- 3. TOGGLE SWITCH ---
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _handleToggle(0),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: _selectedToggleIndex == 0 ? const Color(0xFF00AA4F) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _selectedToggleIndex == 0
                            ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                            : [],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Mobile No.",
                        style: _selectedToggleIndex == 0
                            ? ExperimentStyles.toggleSelected
                            : ExperimentStyles.toggleUnselected,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _handleToggle(1),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: _selectedToggleIndex == 1 ? const Color(0xFF00AA4F) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _selectedToggleIndex == 1
                            ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                            : [],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Digital Account No",
                        style: _selectedToggleIndex == 1
                            ? ExperimentStyles.toggleSelected
                            : ExperimentStyles.toggleUnselected,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // --- 4. SEARCH BAR (Button with Green Line) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _inputLabel,
                  style: ExperimentStyles.inputLabel,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RecipientSearchScreen()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50, // Fixed height to ensure alignment
                    clipBehavior: Clip.hardEdge, // This cuts the green line at the rounded corners
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // THE NEW GREEN LINE
                        Container(
                          width: 5,
                          height: double.infinity, // Stretches top to bottom
                          color: const Color(0xFF00AA4F),
                        ),

                        // THE TEXT & ICON
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10), // Padding is now inside
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Expanded(
                                  child: Text(
                                    "Enter number or select contact",
                                    style: ExperimentStyles.inputHint,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.search, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
