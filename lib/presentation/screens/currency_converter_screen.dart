import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_finance/presentation/providers/movement_provider.dart';
import 'package:smart_finance/presentation/providers/crypto_rate_provider.dart';
import 'package:smart_finance/presentation/providers/dollar_rate_provider.dart';
import 'package:smart_finance/presentation/providers/euro_rate_provider.dart';

class CurrencyConverterScreen extends ConsumerStatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  ConsumerState<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends ConsumerState<CurrencyConverterScreen> {
  final String _fromCurrency = 'ARS';
  String? _toCurrency;
  double _amount = 0;
  bool _useTotalIncome = false;
  final TextEditingController _controller = TextEditingController();

  final Map<String, String> _currencyLabels = {
    'USD': 'Dólar US',
    'EUR': 'Euro',
    'Bitcoin': 'Bitcoin',
    'Ethereum': 'Ethereum',
    'Tether': 'Tether'
  };

  @override
  Widget build(BuildContext context) {
    final totalIncome = ref.watch(availableBalance);
    final cryptoRates = ref.watch(cryptoRateProvider);
    final dollarRates = ref.watch(dollarRateProvider);
    final euroRates = ref.watch(euroRateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Conversor de Moneda')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _fromCurrency,
              items: const [
                DropdownMenuItem(value: 'ARS', child: Text('Pesos Argentinos')),
              ],
              onChanged: (_) {},
              decoration: const InputDecoration(labelText: 'Desde'),
            ),
            const SizedBox(height: 16),
            const Icon(Icons.arrow_downward),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _toCurrency,
              items: _currencyLabels.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (value) => setState(() => _toCurrency = value),
              decoration: const InputDecoration(labelText: 'A'),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Usar total Disponible'),
              value: _useTotalIncome,
              onChanged: (value) {
                setState(() {
                  _useTotalIncome = value!;
                  _controller.text = _useTotalIncome ? totalIncome.toStringAsFixed(2) : '';
                  _amount = _useTotalIncome ? totalIncome : 0;
                });
              },
            ),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cantidad'),
              onChanged: (value) => _amount = double.tryParse(value) ?? 0,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_toCurrency == null || _amount <= 0) return;

                double? result;

                if (_toCurrency == 'USD') {
                  final usd = dollarRates.value?.firstWhere((r) => r.name == 'Dólar Oficial');
                  if (usd != null) result = _amount / usd.sell;
                } else if (_toCurrency == 'EUR') {
                  final eur = euroRates.value?.firstWhere((r) => r.name == 'Euro Oficial');
                  if (eur != null) result = _amount / eur.sell;
                } else if (_toCurrency == 'Bitcoin' ||
                    _toCurrency == 'Ethereum' ||
                    _toCurrency == 'Tether') {
                  final crypto = cryptoRates.value?.firstWhere((r) => r.name == _toCurrency);
                  final usd = dollarRates.value?.firstWhere((r) => r.name == 'Dólar Oficial');
                  if (crypto != null && usd != null) {
                    final arsToUsd = _amount / usd.sell;
                    result = arsToUsd / crypto.price;
                  }
                }

                if (result != null && result > 0) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Resultado'),
                      content: Text('$_amount ARS son ${result!.toStringAsFixed(6)} $_toCurrency'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                      ],
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => const AlertDialog(
                      title: Text('Error'),
                      content: Text('No se pudo calcular la conversión.'),
                    ),
                  );
                }
              },
              child: const Text('Convertir'),
            ),
          ],
        ),
      ),
    );
  }
}
