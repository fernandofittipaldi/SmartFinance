import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dollar_rate_provider.dart';

class DollarRatesScreen extends ConsumerWidget {
  const DollarRatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRates = ref.watch(dollarRateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cotización Dólar')),
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
                    child: Icon(Icons.monetization_on),
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
