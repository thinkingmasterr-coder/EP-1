// File: lib/main.dart

import 'package:flutter/material.dart';
import 'user_data.dart';
import 'send_menu.dart';
import 'screens/my_account_screen.dart'; // Ensure you have created the 'screens' folder

void main() {
  runApp(const EasypaisaApp());
}

class EasypaisaApp extends StatelessWidget {
  const EasypaisaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easypaisa Clone',
      theme: ThemeData(
        primaryColor: const Color(0xFF00AA4F), // Official Easypaisa Green
        scaffoldBackgroundColor: const Color(0xFFF3F4F6), // Light Grey Background
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- 1. APP BAR ---
      appBar: AppBar(
        backgroundColor: const Color(0xFF00AA4F),
        elevation: 0,
        // The "EP" Profile Icon
        leading: GestureDetector(
          onTap: () {
            // Navigates to the My Account / Settings Screen
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyAccountScreen()));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              child: const Text("EP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        // Title and "My Rewards" Badge
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("easypaisa Account", style: TextStyle(fontSize: 14, color: Colors.white)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Text("My Rewards ", style: TextStyle(color: Colors.white, fontSize: 10)),
                  Icon(Icons.monetization_on, color: Color(0xFFFFC107), size: 16), // Gold Coin
                ],
              ),
            )
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
        ],
      ),

      // --- 2. BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF00AA4F),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        showUnselectedLabels: true,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          const BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: "Cash Points"),
          // The Center QR Button
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(top: 4), // Push it down slightly
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF00AA4F),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: const Color(0xFF00AA4F).withOpacity(0.4), blurRadius: 8, offset: const Offset(0,4))
                ]
              ),
              child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
            ),
            label: "",
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.percent), label: "Promotions"),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "My Account"),
        ],
        onTap: (index) {
          if (index == 4) { // Index 4 is "My Account"
             Navigator.push(context, MaterialPageRoute(builder: (context) => const MyAccountScreen()));
          } else if (index != 0) {
             // Show "No Internet" for non-functional tabs
             _showNoInternet(context);
          }
        },
      ),

      // --- 3. BODY CONTENT ---
      body: SingleChildScrollView(
        child: Column(
          children: [
            // A. GREEN HEADER SECTION (Balance)
            Container(
              width: double.infinity,
              color: const Color(0xFF00AA4F),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Available Balance", style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 5),
                          ValueListenableBuilder<double>(
                            valueListenable: UserData.balance,
                            builder: (context, value, child) {
                              return Text(
                                "Rs. ${value.toStringAsFixed(2)}",
                                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                          const SizedBox(height: 5),
                          const Text("Tap to hide balance", style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          _buildHeaderButton("Upgrade Account"),
                          const SizedBox(height: 8),
                          _buildHeaderButton("Add Cash"),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),

            // B. THE WHITE ACTION CARD (Send Money)
            Transform.translate(
              offset: const Offset(0, -10),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 1),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMainAction(context, Icons.send_outlined, "Send Money", isLink: true),
                    _buildMainAction(context, Icons.receipt_long_outlined, "Bill Payment", isLink: false),
                    _buildMainAction(context, Icons.phonelink_ring_outlined, "Mobile Packages", isLink: false),
                  ],
                ),
              ),
            ),

            // C. MORE WITH EASYPAISA (The Grid)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: const Text("More with easypaisa", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  // Row 1
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGridIcon(context, Icons.phone_android, "Easyload"),
                      _buildGridIcon(context, Icons.money, "Easycash Loan"),
                      _buildGridIcon(context, Icons.savings_outlined, "Savings Pocket"),
                      _buildGridIcon(context, Icons.person_add_alt, "Invite & Earn"),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Row 2
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGridIcon(context, Icons.favorite_border, "Pinktober"),
                      _buildGridIcon(context, Icons.account_balance, "Term Deposit"),
                      _buildGridIcon(context, Icons.card_giftcard, "Daily Rewards"),
                      _buildGridIcon(context, Icons.shopping_bag_outlined, "Buy Now Pay Later"),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Row 3
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGridIcon(context, Icons.umbrella_outlined, "Insurance Marketplace"),
                      _buildGridIcon(context, Icons.directions_car, "M-Tag"),
                      _buildGridIcon(context, Icons.sports_esports, "Rs.1 Game"),
                      _buildGridIcon(context, Icons.grid_view, "See All"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40), // Spacing at bottom
          ],
        ),
      ),
    );
  }

  // --- HELPER METHODS ---

  void _showNoInternet(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("No Internet Connection"),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.black87,
      ),
    );
  }

  Widget _buildHeaderButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildMainAction(BuildContext context, IconData icon, String label, {required bool isLink}) {
      return GestureDetector(
        onTap: () {
          if (isLink) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const SendMenu(),
            );
          } else {
             _showNoInternet(context);
          }
        },
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF00AA4F), size: 32),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

  Widget _buildGridIcon(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        _showNoInternet(context);
      },
      child: SizedBox(
        width: 70, // Fixed width helps alignment
        child: Column(
          children: [
            Icon(icon, color: Colors.black54, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}