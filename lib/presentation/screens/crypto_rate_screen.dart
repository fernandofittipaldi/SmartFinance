import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/crypto_rate_provider.dart';

class CryptoRateScreen extends ConsumerWidget {
  const CryptoRateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCrypto = ref.watch(cryptoRateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cotización Criptomonedas')),
      body: asyncCrypto.when(
        data: (list) => ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final crypto = list[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: crypto.image != null ?
                  Image.network(
                    crypto.image!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    )
                  : const SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.money),
                  ),
                title: Text(crypto.name),
                subtitle: Text('Precio: \$${crypto.price.toStringAsFixed(2)} USD'),
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
