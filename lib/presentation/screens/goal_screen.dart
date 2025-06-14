import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_finance/domain/goal.dart'; // Tu domain goal.dart

// Provider para manejar las metas
final goalsProvider = StateNotifierProvider<GoalsNotifier, List<Goal>>((ref) {
  return GoalsNotifier();
});

class GoalsNotifier extends StateNotifier<List<Goal>> {
  GoalsNotifier() : super([]);

  void addGoal(Goal goal) {
    state = [goal, ...state]; // Agregar al inicio de la lista
  }

  void updateGoalAmount(String goalId, double amount) {
    state = state.map((goal) {
      if (goal.name == goalId) { // Usando name como ID ya que no hay id en tu domain
        return Goal(
          name: goal.name,
          targetAmount: goal.targetAmount,
          amountSaved: goal.amountSaved + amount,
          createdAt: goal.createdAt,
        );
      }
      return goal;
    }).toList();
  }
}

class GoalScreen extends ConsumerWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Mis Metas',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: goals.length + 1, // +1 para el botón de agregar
                    itemBuilder: (context, index) {
                      if (index == goals.length) {
                        // Botón para agregar nueva meta
                        return _buildAddButton(context);
                      } else {
                        // Meta existente
                        return _buildGoalCard(context, goals[index]);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/add-goal'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue, width: 2, style: BorderStyle.solid),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 50,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, Goal goal) {
    final progress = goal.targetAmount > 0 ? goal.amountSaved / goal.targetAmount : 0.0;
    final progressPercentage = (progress * 100).clamp(0, 100);

    return GestureDetector(
      onTap: () => context.go('/goal-balance/${goal.name}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightGreen.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                goal.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                '\$${goal.amountSaved.toStringAsFixed(0)} / \$${goal.targetAmount.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              const SizedBox(height: 4),
              Text(
                '${progressPercentage.toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
