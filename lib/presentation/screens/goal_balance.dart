import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_finance/domain/goal.dart';
import 'package:smart_finance/presentation/screens/goal_screen.dart';

class GoalBalanceScreen extends ConsumerStatefulWidget {
  final String goalName;
  
  const GoalBalanceScreen({super.key, required this.goalName});

  @override
  ConsumerState<GoalBalanceScreen> createState() => _GoalBalanceScreenState();
}

class _GoalBalanceScreenState extends ConsumerState<GoalBalanceScreen> {
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

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
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
    final isGoalReached = remainingAmount <= 0;
    final progress = goal.targetAmount > 0 ? goal.amountSaved / goal.targetAmount : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(goal.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/goals'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Información de la meta
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        goal.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Creada el: ${formatDate(goal.createdAt)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const SizedBox(height: 20),
                      
                      // Progreso visual
                      LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isGoalReached ? Colors.green : Colors.blue,
                        ),
                        minHeight: 10,
                      ),
                      const SizedBox(height: 10),
                      
                      // Montos
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Text('Ahorrado'),
                              Text(
                                '\$${goal.amountSaved.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('Meta Total'),
                              Text(
                                '\$${goal.targetAmount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      
                      // Monto restante o mensaje de meta alcanzada
                      if (isGoalReached)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '🎉 ¡Meta Alcanzada! 🎉',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        )
                      else
                        Column(
                          children: [
                            const Text('Falta para completar'),
                            Text(
                              '\$${remainingAmount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 18,
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
              
              // Sección para agregar dinero (solo si la meta no está alcanzada)
              if (!isGoalReached) ...[
                const Text(
                  "Agregar Dinero a la Meta",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                
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
                const SizedBox(height: 20),
                
                ElevatedButton(
                  onPressed: () {
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
                    amountController.clear();
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Dinero agregado con éxito'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Agregar Dinero",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
