import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'goal_screen.dart';
import 'package:smart_finance/domain/goal.dart';

class AddIncomeGoalScreen extends ConsumerStatefulWidget {
  final String goalName;
  
  const AddIncomeGoalScreen({super.key, required this.goalName});

  @override
  ConsumerState<AddIncomeGoalScreen> createState() => _AddIncomeGoalScreenState();
}

class _AddIncomeGoalScreenState extends ConsumerState<AddIncomeGoalScreen> {
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    amountController.text = '';
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(goalsProvider);
    final goal = goals.firstWhere(
      (g) => g.name == widget.goalName,
      orElse: () => Goal(name: 'Meta no encontrada', targetAmount: 0, amountSaved: 0, createdAt: DateTime.now()),
    );

    if (goal.name == 'Meta no encontrada') {
      return Scaffold(
        body: const Center(
          child: Text('Meta no encontrada'),
        ),
      );
    }

    final remainingAmount = goal.targetAmount - goal.amountSaved;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Ingreso'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/goal-balance/${widget.goalName}'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Center(
                child: Text(
                  'Agregar Ingreso a: ${goal.name}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              
              // Información actual de la meta
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
              
              // Monto a agregar
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
              
              // Botón guardar
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final amountText = amountController.text.trim();
                    
                    if (amountText.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, ingresá un monto.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    
                    final amount = double.tryParse(amountText);
                    if (amount == null || amount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El monto ingresado no es válido.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    
                    if (amount > remainingAmount) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El monto ingresado supera al total de la meta.'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }
                    
                    ref.read(goalsProvider.notifier).updateGoalAmount(widget.goalName, amount);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ingreso agregado con éxito'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    
                    context.go('/goal-balance/${widget.goalName}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Guardar Ingreso",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
