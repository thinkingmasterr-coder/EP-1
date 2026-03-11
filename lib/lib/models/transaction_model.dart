class TransactionModel {
  final String type;
  final String bankName;
  final String receiverName;
  final String contactNumber;
  final DateTime dateTime;
  final double amount;
  final bool isSent;

  TransactionModel({
    required this.type,
    required this.bankName,
    required this.receiverName,
    required this.contactNumber,
    required this.dateTime,
    required this.amount,
    required this.isSent,
  });

  // fromJson
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      type: json['type'],
      bankName: json['bankName'],
      receiverName: json['receiverName'],
      contactNumber: json['contactNumber'] ?? '', // Provide a default value
      dateTime: DateTime.parse(json['dateTime']),
      amount: json['amount'],
      isSent: json['isSent'],
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'bankName': bankName,
      'receiverName': receiverName,
      'contactNumber': contactNumber,
      'dateTime': dateTime.toIso8601String(),
      'amount': amount,
      'isSent': isSent,
    };
  }
}