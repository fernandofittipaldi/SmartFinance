import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_finance/presentation/providers/movement_provider.dart';

class BalanceScreen extends ConsumerWidget  {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final incomeTotal = ref.watch(totalIncomeProvider);
  final expenseTotal = ref.watch(totalExpenseProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Saldo',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text("Ingresos Totales"),
                      Text(
                        '\$$incomeTotal',
                        style: const TextStyle(color: Colors.green, fontSize: 20),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Gastos Totales"),
                      Text(
                        '-\$${expenseTotal.toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.push('/add_income');
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade100),
                    child: const Text('Ingresar Saldo'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.push('/add_expense');
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade100),
                    child: const Text('Ingresar Gasto'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilterChip(label: Text("Egresos"), onSelected: (_) {}),
                  FilterChip(label: Text("Ingresos"), onSelected: (_) {}),
                  FilterChip(label: Text("Categoría"), onSelected: (_) {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}




