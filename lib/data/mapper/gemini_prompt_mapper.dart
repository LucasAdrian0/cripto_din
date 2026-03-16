import 'package:cripto_din/domain/entities/noticia_chat.dart';
import 'package:cripto_din/domain/ia/gemini_promp_input.dart';

class GeminiPromptMapper {
  static GeminiPromptInput fromEntities(
    String pergunta,
    List<NoticiaChat> noticias,
  ) {
    final noticiasTexto = noticias.map((n) => n.titulo).join("\n");

    return GeminiPromptInput(
      pergunta: pergunta,
      noticiasTexto: noticiasTexto,
    );
  }
}