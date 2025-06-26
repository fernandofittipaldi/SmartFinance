import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_finance/domain/goal.dart';
import 'package:smart_finance/presentation/providers/goal_provider.dart';
import 'package:smart_finance/presentation/screens/main_scaffold.dart';

class GoalScreen extends ConsumerWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsStreamProvider);

    return MainScaffold(
      currentIndex: 2,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Metas',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: goalsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error al cargar metas: $e')),
                    data: (goals) {
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: goals.length + 1,
                        itemBuilder: (context, index) {
                          if (index == goals.length) {
                            return _buildAddButton(context);
                          } else {
                            return _buildGoalCard(context, goals[index]);
                          }
                        },
                      );
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
      onTap: () => context.push('/add-goal'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: const Center(
          child: Icon(Icons.add, size: 50, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, Goal goal) {
    final progress = goal.targetAmount > 0 ? goal.amountSaved / goal.targetAmount : 0.0;
    final progressPercentage = (progress * 100).clamp(0, 100);

    return GestureDetector(
      onTap: () {
        context.push('/add-income-goal/${goal.id}');
      },
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
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
