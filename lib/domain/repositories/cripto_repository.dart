import 'package:cripto_din/domain/entities/cripto.dart';

abstract class CriptoRepository {
  Stream<List<Cripto>> getCriptomoedas();
  Future<void> salvarCriptomoedas(List<Cripto> criptos);
  Future<bool> atualizarCriptoApos1Minuto();
  Future<List<Cripto>> atualizarCriptoAgora();
}
