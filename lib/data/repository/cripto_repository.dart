import 'package:cripto_din/data/model/cripto_model.dart';

abstract class CriptoRepository {
  Stream<List<CriptoModel>> getCriptomoedas();
  Future<void> salvarCriptomoedas(List<CriptoModel> lista);
  Future<bool> atualizarApos1Minuto();
  Future<List<CriptoModel>> atualizarAgora();
}
