import '../models/transaction_model.dart';
List<TransactionModel> dummyTransactions = [
  TransactionModel(
    type: "Money Transfer",
    bankName: "easypaisa",
    receiverName: "Ali Khan",
    dateTime: DateTime.now().subtract(const Duration(minutes: 5)),
    amount: 500.0,
    isSent: true,
  ),
  TransactionModel(
    type: "Money Transfer",
    bankName: "HBL",
    receiverName: "Fatima Shah",
    dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    amount: 2500.0,
    isSent: false,
  ),
  TransactionModel(
    type: "Bill Payment",
    bankName: "K-Electric",
    receiverName: "Consumer ID: 12345678",
    dateTime: DateTime.now().subtract(const Duration(days: 2)),
    amount: 1200.0,
    isSent: true,
  ),
];