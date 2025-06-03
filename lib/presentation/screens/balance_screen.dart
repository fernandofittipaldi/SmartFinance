import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_finance/presentation/providers/movement_provider.dart';
import 'package:intl/intl.dart';
import 'package:smart_finance/utils/format_utils.dart';

class BalanceScreen extends ConsumerWidget  {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final incomeTotal = ref.watch(totalIncomeProvider);
  final expenseTotal = ref.watch(totalExpenseProvider);
  final selectedFilter = ref.watch(selectedFilterProvider);
  final filterNotifier = ref.read(selectedFilterProvider.notifier);
  final filteredMovements = ref.watch(filteredMovementsProvider);
  final cantView = 6;

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
                        formatCurrency(incomeTotal),
                        style: const TextStyle(color: Colors.green, fontSize: 20),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Gastos Totales"),
                      Text(
                        ('-') + formatCurrency(expenseTotal),
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
                  FilterChip(
                    label: const Text("Ingresos"),
                    selected: selectedFilter == FilterType.income,
                    onSelected: (_) => filterNotifier.state = FilterType.income,
                  ),
                  FilterChip(
                    label: const Text("Egresos"),
                    selected: selectedFilter == FilterType.expense,
                    onSelected: (_) => filterNotifier.state = FilterType.expense,
                  ), 
                  FilterChip(
                    label: const Text("Todos"),
                    selected: selectedFilter == FilterType.all,
                    onSelected: (_) => filterNotifier.state = FilterType.all,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: cantView,
                  itemBuilder: (context, index) {
                    final movement = filteredMovements[index];
                    return ListTile(
                      leading: Icon(
                        movement.isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                        color: movement.isIncome ? Colors.green : Colors.red,
                      ),
                      title: Text(movement.category),
                      subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(movement.date)),
                      trailing: Text(
                        (movement.isIncome ? '+' : '-') + formatCurrency(movement.amount),
                        style: TextStyle(
                          color: movement.isIncome ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                        ),
                      ),
                    );
                  },
                ),
              ) 
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/balance');
              break;
            case 1:
              context.go('/general-balance');
              break;
            case 2:
              context.go('/investments');
              break;
            case 3:
              context.go('/prices');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}




