class CryptoRate {
  final String name;
  final double price;
  final String? image;

  CryptoRate({ 
    required this.name, 
    required this.price, 
    this.image
  });

  factory CryptoRate.fromJson(Map<String, dynamic> json) {
    return CryptoRate(
      name: json['name'],
      price: json['current_price']?.toDouble() ?? 0.0,
      image: json['image']
    );
  }
}
