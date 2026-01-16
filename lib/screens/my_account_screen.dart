// File: lib/screens/my_account_screen.dart

import 'package:flutter/material.dart';
import 'history_screen.dart'; // This connects to the list we made earlier

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00AA4F), // Brand Green
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("My Account", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Profile, Settings & More", style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Green Header Extension with Profile Card
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // Green Background
                Container(
                  height: 60,
                  color: const Color(0xFF00AA4F),
                ),
                // Profile Card (Dark Green)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF005946), // The dark green from screenshot
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Text("FS", style: TextStyle(color: Colors.black, fontSize: 20)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("FATIMA SHAH", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 4),
                            Text("03025529918", style: TextStyle(color: Colors.white70, fontSize: 12)),
                            Text("Register Email", style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      // Edit Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.edit, size: 14, color: Color(0xFF005946)),
                            SizedBox(width: 4),
                            Text("Edit", style: TextStyle(color: Color(0xFF005946), fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 2. The Menu List
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildMenuItem(context, Icons.account_balance_wallet_outlined, "easypaisa Account", null),
                  const Divider(height: 1),
                  _buildMenuItem(context, Icons.arrow_circle_up, "Upgrade Account", null, isNew: true),
                  const Divider(height: 1),

                  // THIS IS THE BUTTON THAT OPENS HISTORY
                  _buildMenuItem(context, Icons.receipt_long, "Transaction History", () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen()));
                  }),

                  const Divider(height: 1),
                  _buildMenuItem(context, Icons.person_outline, "My Account", null),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback? onTap, {bool isNew = false}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isNew)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC107), // Gold/Yellow
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text("NEW", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}