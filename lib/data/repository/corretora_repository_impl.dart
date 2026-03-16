import 'package:cripto_din/domain/entities/corretora.dart';
import 'package:cripto_din/domain/repositories/corretora_repository.dart';

class CorretoraRepositoryImpl implements CorretoraRepository {
  @override
  List<Corretora> getCorretoras() {
    return [
      Corretora(nome: "Binance", url: "https://www.binance.com/"),
      Corretora(nome: "Coinbase", url: "https://www.coinbase.com/"),
      Corretora(nome: "Kraken", url: "https://www.kraken.com/"),
    ];
  }
}