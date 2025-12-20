import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../data/dummy_transactions.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    // 1. Group transactions by Date Key (e.g., "26 November 2025")
    Map<String, List<TransactionModel>> groupedTransactions = {};

    // Sort transactions so newest are always on top
    dummyTransactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    for (var tx in dummyTransactions) {
      String dateKey = DateFormat("d MMMM y").format(tx.dateTime);
      if (!groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey] = [];
      }
      groupedTransactions[dateKey]!.add(tx);
    }

    return Scaffold(
      backgroundColor: Color(0xFFF2F3F5), // Light grey background like real app
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Transaction History",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // Top "Download e-statement" Banner
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download, color: Color(0xFFEA4335), size: 20),
                SizedBox(width: 8),
                Text(
                  "Download e-statement",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),

          // The List
          Expanded(
            child: ListView.builder(
              itemCount: groupedTransactions.keys.length,
              itemBuilder: (context, index) {
                String dateKey = groupedTransactions.keys.elementAt(index);
                List<TransactionModel> transactions = groupedTransactions[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Header (e.g., 26 November 2025)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dateKey,
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500),
                          ),
                          if (index == 0) // Only show sync on first item
                            Row(
                              children: [
                                Text(
                                  "Last sync: ${DateFormat('dd-MMM-yyyy').format(DateTime.now())}",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 10),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.refresh,
                                    size: 14, color: Colors.grey[600])
                              ],
                            ),
                        ],
                      ),
                    ),

                    // Transaction Cards for this Date
                    ...transactions.map((tx) => _buildTransactionCard(tx)).toList(),

                    SizedBox(height: 10), // Spacing between groups
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(TransactionModel tx) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            tx.type == "Money Transfer"
                ? Icons.account_balance_wallet_outlined // Wallet icon
                : Icons.receipt_long_outlined, // Bill icon
            color: Colors.black54,
            size: 20,
          ),
        ),
        title: Text(
          "${tx.bankName} - ${tx.receiverName}",
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            DateFormat('h:mm a').format(tx.dateTime), // e.g. 5:43 PM
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Rs. ${tx.amount.toStringAsFixed(2)}",
              style: TextStyle(
                color: tx.isSent ? Color(0xFFD32F2F) : Color(0xFF00C05E), // Red if sent
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}