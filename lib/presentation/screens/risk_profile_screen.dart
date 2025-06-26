import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_finance/presentation/providers/risk_profile_provider.dart';
import 'package:smart_finance/domain/app_user.dart';

class RiskProfileScreen extends ConsumerStatefulWidget {
  const RiskProfileScreen({super.key});

  @override
  ConsumerState<RiskProfileScreen> createState() => _RiskProfileScreenState();
}

class _RiskProfileScreenState extends ConsumerState<RiskProfileScreen> {
  final Map<String, int> _answers = {};

  final List<Question> _questions = [
    Question(
      text: '¿Qué harías si tu inversión cae un 20% en un mes?',
      options: {
        'Vendo todo': 1,
        'Espero a que se recupere': 2,
        'Invierto más': 3,
      },
    ),
    Question(
      text: '¿Cuánto tiempo pensás dejar tu dinero invertido?',
      options: {'Menos de 1 año': 1, '1 a 3 años': 2, 'Más de 3 años': 3},
    ),
    Question(
      text: '¿Cuál es tu principal objetivo?',
      options: {
        'Preservar capital': 1,
        'Equilibrio entre riesgo y retorno': 2,
        'Maximizar ganancias': 3,
      },
    ),
    Question(
      text: '¿Qué nivel de riesgo estás dispuesto a asumir?',
      options: {'Bajo': 1, 'Medio': 2, 'Alto': 3},
    ),
    Question(
      text: '¿Qué nivel de experiencia tenés en inversiones?',
      options: {'Poca o ninguna': 1, 'Moderada': 2, 'Alta': 3},
    ),
  ];

  Future<void> _evaluateProfile() async {
    final service = ref.read(riskProfileServiceProvider);
    final profile = service.evaluateProfile(_answers);
    await service.saveProfile(profile);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resultado del Perfil'),
        content: Text('Tu perfil de riesgo es: ${_formatProfile(profile)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  String _formatProfile(RiskProfile profile) {
    switch (profile) {
      case RiskProfile.conservative:
        return 'Conservador';
      case RiskProfile.moderate:
        return 'Moderado';
      case RiskProfile.aggressive:
        return 'Arriesgado';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Evaluá tu Perfil de Riesgo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ..._questions.map((question) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ExpansionTile(
                  title: Text(
                    question.text,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: question.options.entries.map((entry) {
                    return RadioListTile<int>(
                      title: Text(entry.key),
                      value: entry.value,
                      groupValue: _answers[question.text],
                      onChanged: (value) {
                        setState(() {
                          _answers[question.text] = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            }),
            ElevatedButton(
              onPressed: _answers.length == _questions.length
                  ? _evaluateProfile
                  : null,
              child: const Text('Evaluar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}

class Question {
  final String text;
  final Map<String, int> options;
  Question({required this.text, required this.options});
}
