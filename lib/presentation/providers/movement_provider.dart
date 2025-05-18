import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_finance/domain/movement.dart';

final movementProvider =
    StateNotifierProvider<MovementNotifier, List<Movement>>(
      (ref) => MovementNotifier(FirebaseFirestore.instance),
    );

class MovementNotifier extends StateNotifier<List<Movement>> {
  final FirebaseFirestore db;

  MovementNotifier(this.db) : super([]){
    getAllMovements();
  }

  Future<void> addMovement(Movement movement) async {
    final doc = db.collection('movements').doc();
    try {
      await doc.set(movement.toFirestore());
      state = [...state, movement];
    } catch (e) {
      print('Error adding movement: $e');
    }
  }

  Future<void> getAllMovements() async {
    final docs = db
        .collection('movements')
        .withConverter(
          fromFirestore: Movement.fromFirestore,
          toFirestore: (Movement movement, _) => movement.toFirestore(),
        );
    final movements = await docs.get();
    state = [...state, ...movements.docs.map((d) => d.data())];
    // final snapshot = await docs.get();
    // state = snapshot.docs.map((doc) => doc.data()).toList();
  }
}

final totalIncomeProvider = Provider<double>((ref) {
  final movements = ref.watch(movementProvider);
  return movements
      .where((m) => m.isIncome)
      .fold(0.0, (sum, m) => sum + m.amount);
});

final totalExpenseProvider = Provider<double>((ref) {
  final movements = ref.watch(movementProvider);
  return movements
      .where((m) => !m.isIncome)
      .fold(0.0, (sum, m) => sum + m.amount);
});
