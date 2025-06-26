import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String? id;
  final String name;
  final double targetAmount;
  final double amountSaved;
  final DateTime createdAt;

  Goal({
    this.id,
    required this.name,
    required this.targetAmount,
    required this.amountSaved,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
  return {
    'name': name,
    'targetAmount': targetAmount,
    'amountSaved': amountSaved,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'targetAmount': targetAmount,
      'amountSaved': amountSaved,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map, {required String id}) {
    return Goal(
      id: id,
      name: map['name'] ?? '',
      targetAmount: (map['targetAmount'] ?? 0).toDouble(),
      amountSaved: (map['amountSaved'] ?? 0).toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Goal copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? amountSaved,
    DateTime? createdAt,
  }) {
    return Goal(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      amountSaved: amountSaved ?? this.amountSaved,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
