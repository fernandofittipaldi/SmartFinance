import 'package:cloud_firestore/cloud_firestore.dart';

class Movement {
  final DateTime date;
  final String category;
  final double amount;
  final bool isIncome;
  final String? uid;

  Movement({
    required this.date,
    required this.category,
    required this.amount,
    required this.isIncome,
    this.uid
  });

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'category': category,
      'amount': amount,
      'isIncome': isIncome,
      'uid': uid
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
      uid: data['uid']
    );
  }

    Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'category': category,
      'amount': amount,
      'isIncome': isIncome,
      'uid': uid
    };
  }

    factory Movement.fromMap(Map<String, dynamic> map) {
    return Movement(
      date: (map['date'] as Timestamp).toDate(),
      category: map['category'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      isIncome: map['isIncome'] ?? true,
    );
  }

}
