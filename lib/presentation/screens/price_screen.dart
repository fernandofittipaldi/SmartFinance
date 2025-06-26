import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_finance/presentation/providers/movement_provider.dart';
import 'package:smart_finance/presentation/screens/balance_screen.dart';
import 'package:smart_finance/presentation/screens/main_scaffold.dart';

class PriceScreen extends ConsumerWidget {
  const PriceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final available = ref.watch(availableBalance);

    return MainScaffold(
      currentIndex: 4,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Cotizaciones',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              AvailableBalance(available: available),
              const SizedBox(height: 30),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.5,
                    children: [
                      _buildPriceButton(
                        context,
                        'Cotización Dólar',
                        () => _navigate(context, 'dolar'),
                      ),
                      _buildPriceButton(
                        context,
                        'Cotización Euro',
                        () => _navigate(context, 'euro'),
                      ),
                      _buildPriceButton(
                        context,
                        'Cotizacion Criptomonedas',
                        () => _navigate(context, 'crypto'),
                      ),
                      _buildPriceButton(
                        context,
                        'Conversor de Moneda',
                        () => _navigate(context, 'conversor'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceButton(
    BuildContext context,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String tipo) {
  switch (tipo) {
    case 'dolar':
      context.push('/dollar-rates');
      break;
    case 'euro':
      context.push('/euro-rates');
      break;
    case 'crypto':
      context.push('/crypto-rates');
      break;
    case 'conversor':
      context.push('/currency-converter');
      break;
    default:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Elegiste: $tipo')),
      );
  }
}

}
