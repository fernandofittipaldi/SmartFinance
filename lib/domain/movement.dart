import 'package:cloud_firestore/cloud_firestore.dart';

class Movement {
  final DateTime date;
  final String category;
  final double amount;
  final bool isIncome;

  Movement({
    required this.date,
    required this.category,
    required this.amount,
    required this.isIncome,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'category': category,
      'amount': amount,
      'isIncome': isIncome
    };
  }

  static Movement fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return Movement(
      date: (data['date'] as Timestamp).toDate(),
      category: data['category'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      isIncome: data['isIncome'] ?? true,
    );
  }
}
