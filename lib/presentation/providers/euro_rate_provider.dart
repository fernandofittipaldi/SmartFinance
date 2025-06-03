import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_finance/domain/euro_rate.dart';

final euroRateProvider = FutureProvider<List<EuroRate>>((ref) async {
  final response = await http.get(Uri.parse('https://api.bluelytics.com.ar/v2/latest'));
  final data = json.decode(response.body);

  return [
    EuroRate(
      name: 'Euro Oficial', 
      buy: data['oficial_euro']['value_buy'], 
      sell: data['oficial_euro']['value_sell']),
    EuroRate(
      name: 'Euro Blue', 
      buy: data['blue_euro']['value_buy'], 
      sell: data['blue_euro']['value_sell']),  
  ];
});