import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_finance/domain/app_user.dart';
import 'package:smart_finance/presentation/providers/app_user_provider.dart';
import 'package:smart_finance/services/gemini_service.dart';

class InvestmentSuggestionsScreen extends ConsumerStatefulWidget {
  const InvestmentSuggestionsScreen({super.key});

  @override
  ConsumerState<InvestmentSuggestionsScreen> createState() =>
      _InvestmentSuggestionsScreenState();
}

class _InvestmentSuggestionsScreenState
    extends ConsumerState<InvestmentSuggestionsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  bool isLoading = false;

  String? suggestion;

  void _generateSuggestions() async {
    final appUser = ref.read(appUserProvider);
    final profile = appUser?.riskProfile;
    final amount = double.tryParse(_amountController.text);

    if (profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero evaluá tu perfil de riesgo')),
      );
      return;
    }

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresá un monto válido para invertir')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      suggestion = null;
    });

    try {
      final response = await GeminiService().getInvestmentSuggestion(
        profile,
        amount,
      );
      setState(() {
        suggestion = response;
      });
    } catch (e) {
      setState(() {
        suggestion =
            'Error al obtener sugerencias de inversión. Intentalo más tarde.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appUser = ref.read(appUserProvider);
    final profile = appUser?.riskProfile;    

    return Scaffold(
      appBar: AppBar(title: const Text('¿Dónde Invertir?')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            profile == null
                ? const Center(
                  child: Text('Primero evaluá tu perfil de riesgo.',
                     style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                )
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tu perfil de riesgo: ${profile.displayName}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Monto a invertir (en ARS)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _generateSuggestions,
                          child: const Text('Obtener recomendaciones'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (suggestion != null)
                        Card(
                          elevation: 4,
                          color: Colors.lightGreen.shade100,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              suggestion!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
      ),
    );
  }
}
