
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'user_data.dart';
import 'models/transaction_model.dart';
import 'receipt_screen.dart';

class TransferHistoryScreen extends StatelessWidget {
  const TransferHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<TransactionModel>>(
      valueListenable: UserData.transactions,
      builder: (context, transactions, _) {
        // Group transactions by date
        Map<String, List<TransactionModel>> grouped = {};
        for (var tx in transactions) {
          String dateKey = DateFormat('dd MMMM yyyy').format(tx.dateTime);
          if (!grouped.containsKey(dateKey)) {
            grouped[dateKey] = [];
          }
          grouped[dateKey]!.add(tx);
        }

        List<String> sortedDates = grouped.keys.toList();

        return Column(
          children: [
            _buildLastUpdated(),
            _buildFilterChips(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: sortedDates.length,
                itemBuilder: (context, index) {
                  String date = sortedDates[index];
                  List<TransactionModel> dailyTxs = grouped[date]!;

                  return Column(
                    children: [
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          date,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...dailyTxs.asMap().entries.map((entry) {
                        TransactionModel tx = entry.value;
                        int globalIndex = transactions.indexOf(tx);

                        // Resolve Account Title if available in contacts
                        String displayName = tx.receiverName;
                        String? accountTitle;
                        if (tx.contactNumber.isNotEmpty) {
                          try {
                            final contact = UserData.contacts.value.firstWhere(
                              (c) => c['number'] == tx.contactNumber,
                            );
                            if (contact['accountTitle'] != null && contact['accountTitle']!.isNotEmpty) {
                              displayName = contact['accountTitle']!;
                              accountTitle = displayName;
                            }
                          } catch (_) {}
                        }

                        void onViewReceipt() {
                          if (tx.isDummy) return;
                          
                          // Show receipt for real transactions
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ReceiptScreen(
                              amount: tx.amount.toStringAsFixed(0),
                              contactName: tx.receiverName,
                              contactNumber: tx.contactNumber,
                              fetchedAccountTitle: accountTitle,
                              dateTime: tx.dateTime,
                            ),
                          );
                        }

                        Widget card = tx.isSent
                            ? _buildSentCard(
                                recipient: displayName,
                                amount: 'Rs. ${tx.amount.toStringAsFixed(2)}',
                                time: DateFormat('h:mm a').format(tx.dateTime),
                                isDummy: tx.isDummy,
                                onDelete: () => _showDeleteConfirmation(context, globalIndex),
                                onViewReceipt: onViewReceipt,
                              )
                            : _buildReceivedCard(
                                sender: displayName,
                                amount: 'Rs. ${tx.amount.toStringAsFixed(2)}',
                                time: DateFormat('h:mm a').format(tx.dateTime),
                                isDummy: tx.isDummy,
                                onDelete: () => _showDeleteConfirmation(context, globalIndex),
                                onViewReceipt: onViewReceipt,
                              );

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Align(
                            alignment: tx.isSent ? Alignment.centerRight : Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: tx.isSent ? 0.85 : 0.92,
                              child: card,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Transaction"),
        content: const Text("Are you sure you want to delete this transaction from history?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              UserData.deleteTransaction(index);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdated() {
    String today = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        'Last Updated: $today',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildChip('All', isSelected: true),
            const SizedBox(width: 8),
            _buildChip('easypaisa'),
            const SizedBox(width: 8),
            _buildChip('Bank Transfer'),
            const SizedBox(width: 8),
            _buildChip('CNIC'),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF00A651) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? const Color(0xFF00A651) : Colors.black26,
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSentCard({
    required String recipient,
    required String amount,
    required String time,
    required bool isDummy,
    required VoidCallback onDelete,
    required VoidCallback onViewReceipt,
  }) {
    return GestureDetector(
      onLongPress: onDelete,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFDFF4F4),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF00BCD4), width: 1.5),
                      ),
                      child: const Icon(Icons.arrow_upward, color: Color(0xFF00BCD4), size: 14),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Money Sent to easypaisa',
                      style: TextStyle(
                        color: Color(0xFF00BCD4),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  time,
                  style: const TextStyle(color: Colors.black54, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'To:  ',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    TextSpan(
                      text: recipient,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Rs. ',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextSpan(
                      text: amount.replaceAll('Rs. ', ''),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: Colors.black12, height: 1),
            const SizedBox(height: 8),
            InkWell(
              onTap: isDummy ? null : onViewReceipt,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('View Receipt', style: TextStyle(color: Colors.black87, fontSize: 11)),
                  const SizedBox(width: 6),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00A651),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 9),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: Colors.black12, height: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Repeat Transaction', style: TextStyle(color: Colors.black87, fontSize: 11)),
                SizedBox(width: 6),
                Icon(Icons.refresh, color: Color(0xFF00A651), size: 15),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceivedCard({
    required String sender,
    required String amount,
    required String time,
    required bool isDummy,
    required VoidCallback onDelete,
    required VoidCallback onViewReceipt,
  }) {
    return GestureDetector(
      onLongPress: onDelete,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0FAF0),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF00A651), width: 1.5),
                      ),
                      child: const Icon(Icons.arrow_downward, color: Color(0xFF00A651), size: 14),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Money Received from easypaisa',
                      style: TextStyle(
                        color: Color(0xFF00A651),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  time,
                  style: const TextStyle(color: Colors.black54, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'From:  ',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    TextSpan(
                      text: sender,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Rs. ',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextSpan(
                      text: amount.replaceAll('Rs. ', ''),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: Colors.black12, height: 1),
            const SizedBox(height: 8),
            InkWell(
              onTap: isDummy ? null : onViewReceipt,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('View Receipt', style: TextStyle(color: Colors.black87, fontSize: 11)),
                  const SizedBox(width: 6),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00A651),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 9),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: Colors.black12, height: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Repeat Transaction', style: TextStyle(color: Colors.black87, fontSize: 11)),
                SizedBox(width: 6),
                Icon(Icons.refresh, color: Color(0xFF00A651), size: 15),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
