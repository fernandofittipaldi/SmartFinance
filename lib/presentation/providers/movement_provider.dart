import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_finance/domain/movement.dart';
import 'package:smart_finance/presentation/providers/app_user_provider.dart';

enum FilterType { all, income, expense }

final selectedFilterProvider = StateProvider<FilterType>((ref) => FilterType.all);

final filteredMovementsProvider = Provider<List<Movement>>((ref) {
  final filter = ref.watch(selectedFilterProvider);
  final movements = ref.watch(movementProvider);

  switch (filter) {
    case FilterType.income:
      return movements.where((m) => m.isIncome).toList()..sort((a, b) => b.date.compareTo(a.date));
    case FilterType.expense:
      return movements.where((m) => !m.isIncome).toList()..sort((a, b) => b.date.compareTo(a.date));
    case FilterType.all:
    return movements.toList()..sort((a, b) => b.date.compareTo(a.date));
  }
});

final movementProvider = StateNotifierProvider<MovementNotifier, List<Movement>>((ref) {
  final firestore = FirebaseFirestore.instance;
  final user = ref.watch(appUserProvider);

  final notifier = MovementNotifier(firestore);

  if (user != null) {
    notifier.getAllMovements(user.uid);
  } else {
    notifier.clear();
  }
  return notifier;
});

class MovementNotifier extends StateNotifier<List<Movement>> {
  final FirebaseFirestore db;
    MovementNotifier(this.db) : super([]);

  void clear() {
    state = [];
  }

  Future<void> addMovement(Movement movement) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = db.collection('users').doc(user.uid).collection('movements').doc();

    final movementWithUid = Movement(
      date: movement.date,
      category: movement.category,
      amount: movement.amount,
      isIncome: movement.isIncome,
      uid: user.uid,
    );

    try {
      await doc.set(movementWithUid.toFirestore());
      state = [...state, movementWithUid];
    } catch (e) {
      print('Error adding movement: $e');
    }
  }

  Future<void> getAllMovements(String uid ) async {
    final docs = db
        .collection('users')
        .doc(uid)
        .collection('movements')
        .withConverter(
          fromFirestore: Movement.fromFirestore,
          toFirestore: (Movement movement, _) => movement.toFirestore(),
        );

    final snapshot = await docs.get();
    state = snapshot.docs.map((doc) => doc.data()).toList();
  }
}

final totalIncomeProvider = Provider<double>((ref) {
  final movements = ref.watch(movementProvider);
  return movements
      .where((m) => m.isIncome)
      .fold(0, (sum, m) => sum + m.amount);
});

final totalExpenseProvider = Provider<double>((ref) {
  final movements = ref.watch(movementProvider);
  return movements
      .where((m) => !m.isIncome)
      .fold(0, (sum, m) => sum + m.amount);
});

final availableBalance = Provider<double>((ref) {
  final income = ref.watch(totalIncomeProvider);
  final expense = ref.watch(totalExpenseProvider);
  return income - expense;
});
