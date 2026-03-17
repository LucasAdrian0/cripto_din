import 'package:cripto_din/domain/entities/cripto.dart';

abstract class IARepository {
  Future<String> gerarResposta({
    required String pergunta,
    required List<Cripto> criptos,
  });
}
