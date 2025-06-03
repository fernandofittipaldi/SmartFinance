import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:smart_finance/domain/crypto_rate.dart';

final cryptoRateProvider = FutureProvider<List<CryptoRate>>((ref) async {
  final url = Uri.parse(
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false');

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.map((e) => CryptoRate.fromJson(e)).toList();
  } else {
    throw Exception('Error al cargar las cotizaciones de criptomonedas');
  }
});
