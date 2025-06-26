import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_finance/presentation/providers/app_user_provider.dart';
import '../../domain/goal.dart';

class GoalsNotifier extends StateNotifier<List<Goal>> {
  final Ref ref;

  GoalsNotifier(this.ref) : super([]) {
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final appUser = ref.watch(appUserProvider);
    if (appUser == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(appUser.uid)
        .collection('goals')
        .get();

    state = snapshot.docs
        .map((doc) => Goal.fromMap(doc.data(), id: doc.id))
        .toList();
  }

  Future<void> addGoal(Goal goal) async {
    final appUser = ref.read(appUserProvider);
    if (appUser == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(appUser.uid)
        .collection('goals')
        .doc();

    final newGoal = goal.copyWith(id: docRef.id);
    
    try {
      await docRef.set(newGoal.toFirestore());
      state = [newGoal, ...state];
    } catch (e) {
      print('Error adding goal: $e');
    }      
  }

  Future<void> addAmountToGoal(String goalId, double amount) async {
    final appUser = ref.read(appUserProvider);
    if (appUser == null) return;

    final index = state.indexWhere((g) => g.id == goalId);
    if (index == -1) return;

    final goal = state[index];
    final updatedGoal = goal.copyWith(
      amountSaved: goal.amountSaved + amount,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(appUser.uid)
        .collection('goals')
        .doc(goalId)
        .update({'amountSaved': updatedGoal.amountSaved});

    state = [
      ...state.sublist(0, index),
      updatedGoal,
      ...state.sublist(index + 1),
    ];
  }
}

final goalsNotifierProvider =
    StateNotifierProvider<GoalsNotifier, List<Goal>>((ref) {
  return GoalsNotifier(ref);
});

final goalsStreamProvider = StreamProvider<List<Goal>>((ref) {
  final appUser = ref.watch(appUserProvider);

  if (appUser == null) {
    return const Stream.empty();
  }

  final goalsRef = FirebaseFirestore.instance
      .collection('users')
      .doc(appUser.uid)
      .collection('goals')
      .orderBy('createdAt', descending: true);

  return goalsRef.snapshots().map((snapshot) {
    return snapshot.docs
        .map((doc) => Goal.fromMap(doc.data(), id: doc.id))
        .toList();
  });
});
