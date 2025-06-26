import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_finance/domain/goal.dart';
import 'package:smart_finance/presentation/providers/goal_provider.dart';

class AddIncomeGoalScreen extends ConsumerStatefulWidget {
  final String goalId;

  const AddIncomeGoalScreen({super.key, required this.goalId});

  @override
  ConsumerState<AddIncomeGoalScreen> createState() => _AddIncomeGoalScreenState();
}

class _AddIncomeGoalScreenState extends ConsumerState<AddIncomeGoalScreen> {
  final TextEditingController amountController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(goalsNotifierProvider);

    final goal = goals.firstWhere(
      (g) => g.id == widget.goalId,
      orElse: () => Goal(
        id: '',
        name: 'Meta no encontrada',
        targetAmount: 0,
        amountSaved: 0,
        createdAt: DateTime.now(),
      ),
    );

    if (goal.id!.isEmpty) {
      return Scaffold(
        body: const Center(child: Text('Meta no encontrada')),
      );
    }

    final remainingAmount = goal.targetAmount - goal.amountSaved;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Ingreso'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Agregar Ingreso a: ${goal.name}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Ahorrado actual:'),
                          Text(
                            '\$${goal.amountSaved.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Falta para completar:'),
                          Text(
                            '\$${remainingAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
              const Text("Monto del Ingreso"),
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '\$',
                    border: InputBorder.none,
                    hintText: '0',
                  ),
                ),
              ),
              const SizedBox(height: 40),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final amountText = amountController.text.trim();
                    if (amountText.isEmpty) {
                      _showMessage('Por favor, ingresá un monto.', Colors.red);
                      return;
                    }

                    final amount = double.tryParse(amountText);
                    if (amount == null || amount <= 0) {
                      _showMessage('El monto ingresado no es válido.', Colors.red);
                      return;
                    }

                    if (amount > remainingAmount) {
                      _showMessage('El monto ingresado supera el total restante.', Colors.orange);
                      return;
                    }

                    await ref.read(goalsNotifierProvider.notifier).addAmountToGoal(widget.goalId, amount);
                    _showMessage('Ingreso agregado con éxito', Colors.green);

                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Guardar Ingreso", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }
}
