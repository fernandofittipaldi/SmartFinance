import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_finance/domain/dollar_rate.dart';

final dollarRateProvider = FutureProvider<List<DollarRate>>((ref) async {
  final response = await http.get(Uri.parse('https://api.bluelytics.com.ar/v2/latest'));
  final data = json.decode(response.body);

  return [
    DollarRate(
      name: 'Dólar Oficial', 
      buy: data['oficial']['value_buy'], 
      sell: data['oficial']['value_sell']),
    DollarRate(
      name: 'Dólar Blue', 
      buy: data['blue']['value_buy'], 
      sell: data['blue']['value_sell']),  
  ];
});