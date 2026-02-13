class CriptoModel {
  final String id;
  final String name;
  final String symbol;
  final String image;
  final double price;
  final double change24h;

  CriptoModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.price,
    required this.change24h,
  });

  //Vindo da API (CoinGecko)
  factory CriptoModel.fromApiJson(Map<String, dynamic> json) {
    return CriptoModel(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      image: json['image'],
      price: (json['current_price'] as num).toDouble(),
      change24h:
          (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
    );
  }

  //Vindo do Firestore
  factory CriptoModel.fromMap(Map<String, dynamic> map) {
    return CriptoModel(
      id: map['id'],
      name: map['name'],
      symbol: map['symbol'],
      image: map['image'],
      price: (map['price'] as num).toDouble(),
      change24h: (map['change24h'] as num?)?.toDouble() ?? 0.0,
    );
  }

  //Para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'image': image,
      'price': price,
      'change24h': change24h,
    };
  }
}
