import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_finance/presentation/providers/app_user_provider.dart';
import 'package:smart_finance/presentation/providers/goal_provider.dart';
import '../../domain/goal.dart';


class AddGoalScreen extends ConsumerStatefulWidget {
  const AddGoalScreen({super.key});

  @override
  ConsumerState<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends ConsumerState<AddGoalScreen> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> _saveGoal() async {
    final nameText = nameController.text.trim();
    final amountText = amountController.text.trim();

    if (nameText.isEmpty || amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos'), backgroundColor: Colors.red),
      );
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Monto inválido'), backgroundColor: Colors.red),
      );
      return;
    }

    final user = ref.watch(appUserProvider);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay sesión activa'), backgroundColor: Colors.red),
      );
      return;
    }

    final goal = Goal(
      name: nameText,
      targetAmount: amount,
      amountSaved: 0.0,
      createdAt: selectedDate,
    );

    try {
      await ref.read(goalsNotifierProvider.notifier).addGoal(goal);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meta guardada exitosamente'), backgroundColor: Colors.green),
      );
      context.go('/goals');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Meta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre de la meta'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Monto objetivo'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Fecha de creación: '),
                Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Elegir fecha'),
                )
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              onPressed: _saveGoal,
              label: const Text('Guardar Meta'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
          ],
        ),
      ),
    );
  }
}
