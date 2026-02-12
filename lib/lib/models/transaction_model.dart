class TransactionModel {
  final String type;
  final String bankName;
  final String receiverName;
  final DateTime dateTime;
  final double amount;
  final bool isSent;

  TransactionModel({
    required this.type,
    required this.bankName,
    required this.receiverName,
    required this.dateTime,
    required this.amount,
    required this.isSent,
  });
}