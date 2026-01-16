import 'package:flutter/material.dart';
import 'user_data.dart';
import 'amount_screen.dart'; // Connects to the new screen

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  String searchQuery = "";

  // Helper to open the Amount Screen
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
        title: const Text("Send Money", style: TextStyle(color: Colors.black, fontSize: 16)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // TABS
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFF00AA4F), width: 3)),
                  ),
                  child: const Text("Send Money", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF00AA4F), fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: const Text("History", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                ),
              ),
            ],
          ),

          // FAVORITES SECTION
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("My Easypaisa Favorites", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("See All", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: UserData.contacts.map((contact) {
                      return GestureDetector(
                        onTap: () => _goToAmountScreen(contact), // CLICKABLE FAVORITE
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey[200],
                                child: Text(contact["initials"]!, style: const TextStyle(color: Color(0xFF00AA4F))),
                              ),
                              const SizedBox(height: 8),
                              Text(contact["name"]!, style: const TextStyle(fontSize: 10)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // TOGGLE SWITCH
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(25)),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(color: const Color(0xFF00AA4F), borderRadius: BorderRadius.circular(25)),
                    child: const Text("Mobile No.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  child: const Text("Digital Account No", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Enter Receiver's Mobile Number", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Receiver's Number or select from contacts",
                    hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                    suffixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF00AA4F))),
                  ),
                ),
              ],
            ),
          ),

          // CONTACT LIST
          Expanded(
            child: ListView.builder(
              itemCount: UserData.contacts.length,
              itemBuilder: (context, index) {
                final contact = UserData.contacts[index];
                if (searchQuery.isEmpty || contact["number"]!.contains(searchQuery)) {
                  return ListTile(
                    leading: CircleAvatar(
                       backgroundColor: Colors.green[50],
                       child: Text(contact["initials"]!, style: const TextStyle(color: Color(0xFF00AA4F))),
                    ),
                    title: Text(contact["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(contact["number"]!),
                    trailing: const Icon(Icons.send, color: Color(0xFF00AA4F)),
                    onTap: () => _goToAmountScreen(contact), // CLICKABLE LIST ITEM
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}