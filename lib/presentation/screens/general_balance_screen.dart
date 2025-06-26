import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_finance/presentation/providers/movement_provider.dart';
import 'package:smart_finance/presentation/screens/balance_screen.dart';
import 'package:smart_finance/presentation/screens/main_scaffold.dart';
import 'package:smart_finance/presentation/screens/movement_result_screen.dart';
import 'package:smart_finance/utils/format_utils.dart';

enum FilterOption { income, expense, all }

class GeneralBalanceScreen extends ConsumerStatefulWidget {
  const GeneralBalanceScreen({super.key});

  @override
  ConsumerState<GeneralBalanceScreen> createState() => _GeneralBalanceScreenState();
}

class _GeneralBalanceScreenState extends ConsumerState<GeneralBalanceScreen> {
  bool showFilters = false;
  DateTimeRange? selectedDateRange;
  FilterOption selectedFilter = FilterOption.all;

  @override
  Widget build(BuildContext context) {
    final available = ref.watch(availableBalance);
    final incomeTotal = ref.watch(totalIncomeProvider);
    final expenseTotal = ref.watch(totalExpenseProvider);

    return MainScaffold(
      currentIndex: 1,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              const Text(
                'Balance General',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              AvailableBalance(available: available),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text("Ingresos Totales"),
                      Text(
                        formatCurrency(incomeTotal),
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                        ),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showFilters = !showFilters;
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade100),
                child: const Text('Consultar Movimientos'),
              ),
              if (showFilters) ...[
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDateRange = picked;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    selectedDateRange == null
                        ? "Seleccionar Rango de Fechas"
                        : "${DateFormat('dd/MM/yyyy').format(selectedDateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.end)}",
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Filtrar por tipo:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    RadioListTile<FilterOption>(
                      title: const Text("Ingresos"),
                      value: FilterOption.income,
                      groupValue: selectedFilter,
                      onChanged: (value) {
                        setState(() {
                          selectedFilter = value!;
                        });
                      },
                    ),
                    RadioListTile<FilterOption>(
                      title: const Text("Egresos"),
                      value: FilterOption.expense,
                      groupValue: selectedFilter,
                      onChanged: (value) {
                        setState(() {
                          selectedFilter = value!;
                        });
                      },
                    ),
                    RadioListTile<FilterOption>(
                      title: const Text("Todos"),
                      value: FilterOption.all,
                      groupValue: selectedFilter,
                      onChanged: (value) {
                        setState(() {
                          selectedFilter = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: selectedDateRange != null
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MovementResultScreen(
                                filter: selectedFilter,
                                range: selectedDateRange!,
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade100),
                  child: const Text("Consultar"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
