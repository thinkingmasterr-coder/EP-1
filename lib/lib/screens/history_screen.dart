import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import 'package:collection/collection.dart';
import '../user_data.dart';
import '../receipt_screen.dart';
import '../qr_receipt_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _navigateToReceipt(TransactionModel transaction) {
    if (transaction.isDummy) return;

    if (transaction.type.contains('QR Payment')) {
      showDialog(
        context: context,
        barrierColor: Colors.black87,
        builder: (BuildContext context) {
          return QrReceiptScreen(
            amount: transaction.amount.toStringAsFixed(0),
            storeName: transaction.receiverName,
            isSpecialQr: transaction.type.startsWith('Easypaisa'),
            dateTime: transaction.dateTime,
          );
        },
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptScreen(
          amount: transaction.amount.toStringAsFixed(0),
          contactName: transaction.receiverName,
          contactNumber: transaction.contactNumber,
          dateTime: transaction.dateTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Transaction History",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ValueListenableBuilder<List<TransactionModel>>(
        valueListenable: UserData.transactions,
        builder: (context, allTransactions, child) {
          if (allTransactions.isEmpty) {
            return const Center(
              child: Text(
                'No transactions yet.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          final sortedList = List<TransactionModel>.from(allTransactions)
            ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

          Map<String, List<TransactionModel>> groupedTransactions =
              groupBy(sortedList, (tx) => DateFormat("d MMMM y").format(tx.dateTime));

          var sortedKeys = groupedTransactions.keys.toList()
            ..sort((a, b) => DateFormat("d MMMM y")
                .parse(b)
                .compareTo(DateFormat("d MMMM y").parse(a)));

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.download, color: Color(0xFFEA4335), size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Download e-statement",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sortedKeys.length,
                  itemBuilder: (context, index) {
                    String dateKey = sortedKeys[index];
                    List<TransactionModel> transactions =
                        groupedTransactions[dateKey]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dateKey,
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11),
                              ),
                              if (index == 0)
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 10),
                                    children: <TextSpan>[
                                      const TextSpan(text: 'Last sync: '),
                                      TextSpan(
                                          text: DateFormat('dd-MMM-yyyy')
                                              .format(DateTime.now()),
                                          style: const TextStyle(
                                              color: Colors.grey)),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: transactions.length,
                              itemBuilder: (context, i) {
                                return _buildTransactionTile(transactions[i]);
                              },
                              separatorBuilder: (context, i) {
                                return const Divider(height: 1);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTransactionTile(TransactionModel tx) {
    return ListTile(
      onTap: tx.isDummy ? null : () => _navigateToReceipt(tx),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Image.asset('assets/wallet_ik.png'),
      ),
      title: Text(
        "${tx.type} - ${tx.receiverName}",
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
            height: 1.2),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Text(
          DateFormat('h:mm a').format(tx.dateTime),
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Rs. ${tx.amount.toStringAsFixed(2)}",
            style: TextStyle(
              color:
                  tx.isSent ? const Color(0xFFD32F2F) : const Color(0xFF00C05E),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
