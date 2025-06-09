import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String name;
  final double targetAmount;
  final double amountSaved;
  final DateTime createdAt;

  Goal({
    required this.name,
    required this.targetAmount,
    required this.amountSaved,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'targetAmount': targetAmount,
      'amountSaved': amountSaved,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      name: map['name'] ?? '',
      targetAmount: (map['targetAmount'] ?? 0).toDouble(),
      amountSaved: (map['amountSaved'] ?? 0).toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
