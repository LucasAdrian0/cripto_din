import 'package:cripto_din/domain/entities/cripto.dart';

class CriptoModel extends Cripto {
  CriptoModel({
    required super.id,
    required super.name,
    required super.symbol,
    required super.image,
    required super.price,
    required super.change24h,
  });

  /// Cria um modelo a partir da entidade de domínio
  factory CriptoModel.fromEntity(Cripto cripto) {
    return CriptoModel(
      id: cripto.id,
      name: cripto.name,
      symbol: cripto.symbol,
      image: cripto.image,
      price: cripto.price,
      change24h: cripto.change24h,
    );
  }

  /// Converte o modelo de volta para a entidade de domínio
  Cripto toEntity() {
    return Cripto(
      id: id,
      name: name,
      symbol: symbol,
      image: image,
      price: price,
      change24h: change24h,
    );
  }
}
