//Responsabilidade: Mapeamento e adaptações entre classe e model
import 'package:cripto_din/data/model/cripto_model.dart';

class CriptoMapper {
  //Converte dados da API CoinGecko para o modelo CriptoModel
  static CriptoModel fromApiJson(Map<String, dynamic> json) {
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

  // Converte um Map do Firestore em um CriptoModel
  static CriptoModel fromMap(Map<String, dynamic> map) {
    return CriptoModel(
      id: map['id'],
      name: map['name'],
      symbol: map['symbol'],
      image: map['image'],
      price: (map['price'] as num).toDouble(),
      change24h: (map['change24h'] as num?)?.toDouble() ?? 0.0,
    );
  }

  //Converte um CriptoModel em Map para salvar no Firestore
  static Map<String, dynamic> toMap(CriptoModel cripto) {
    return {
      'id': cripto.id,
      'name': cripto.name,
      'symbol': cripto.symbol,
      'image': cripto.image,
      'price': cripto.price,
      'change24h': cripto.change24h,
    };
  }
}
