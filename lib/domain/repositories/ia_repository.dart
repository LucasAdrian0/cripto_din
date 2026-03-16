import 'package:cripto_din/data/mapper/noticias_to_chat_mapper.dart';
import 'package:cripto_din/domain/entities/cripto.dart';

abstract class AIRepository {
  Future<String> gerarResposta({
    required String pergunta,
    required List<Cripto> criptos,
    required List<NoticiaToChatMapper> noticias,
  });
}
