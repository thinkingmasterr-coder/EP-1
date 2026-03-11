import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

class TransactionReceiptScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionReceiptScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Receipt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${transaction.type}'),
            Text('Bank: ${transaction.bankName}'),
            Text('Receiver: ${transaction.receiverName}'),
            Text('Amount: ${transaction.amount}'),
            Text('Date: ${DateFormat("d MMMM y, h:mm a").format(transaction.dateTime)}'),
          ],
        ),
      ),
    );
  }
}
