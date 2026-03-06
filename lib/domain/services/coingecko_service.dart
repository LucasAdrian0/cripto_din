import 'package:cripto_din/data/model/cripto_model.dart';

abstract class CoingeckoService {
  Future<List<CriptoModel>> listaDeCriptomoedas();
}
