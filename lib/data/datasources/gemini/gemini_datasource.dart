import 'package:cripto_din/domain/entities/cripto.dart';
import 'package:cripto_din/domain/entities/noticia_chat.dart';

abstract class GeminiDatasource {
  Future<String> perguntarIA({
    required String pergunta,
    required List<Cripto> criptos,
    required List<NoticiaChat> noticias,
  });
}