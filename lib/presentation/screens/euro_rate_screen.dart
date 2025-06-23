import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_finance/presentation/providers/euro_rate_provider.dart';

class EuroRateScreen extends ConsumerWidget {
  const EuroRateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRates = ref.watch(euroRateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cotización Euro')),
      body: asyncRates.when(
        data: (rates) => ListView.builder(
          itemCount: rates.length,
          itemBuilder: (context, index) {
            final rate = rates[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.euro),
                  ),
                title: Text(rate.name),
                subtitle: Text('Compra: \$${rate.buy} - Venta: \$${rate.sell}'),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}