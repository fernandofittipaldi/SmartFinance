class CryptoRate {
  final String name;
  final double price;

  CryptoRate({
    required this.name, 
    required this.price
  });

  factory CryptoRate.fromJson(Map<String, dynamic> json) {
    return CryptoRate(
      name: json['name'],
      price: json['current_price']?.toDouble() ?? 0.0,
    );
  }
}
