import 'package:cripto_din/model/cripto_model.dart';

abstract class CriptoRepository {
  Stream<List<CriptoModel>> getCriptomoedas();
  Future<void> salvarCriptomoedas(List<CriptoModel> lista);
  Future<bool> atualizarApos1Hora();
  Future<List<CriptoModel>> atualizarAgora();
}
