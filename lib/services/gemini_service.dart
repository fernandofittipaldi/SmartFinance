// lib/services/gemini_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_finance/domain/app_user.dart';

class GeminiService {
  final String _apiKey = 'API_KEY';

  Future<String> getInvestmentSuggestion(RiskProfile riskProfile, double amount) async {
    const endpoint = 'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent';

    final headers = {
      'Content-Type': 'application/json',
      'x-goog-api-key': _apiKey,
    };

    final prompt = '''
Sos un asesor financiero profesional con mas de 20 años de experiencia. El usuario tiene un perfil de riesgo $riskProfile y desea invertir $amount pesos argentinos. Recomendale instrumentos financieros adecuados y explicá por qué.
''';

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    });

    final response = await http.post(
      Uri.parse(endpoint),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['candidates'][0]['content']['parts'][0]['text'];
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      return 'Error al obtener la recomendación.';
    }
  }
}
