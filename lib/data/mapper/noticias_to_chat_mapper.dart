// data/mapper/noticia_to_chat_mapper.dart
import '../../domain/entities/noticia_chat.dart';
import '../../domain/entities/noticias.dart';

class NoticiaToChatMapper {
  static NoticiaChat map(Noticias n) {
    return NoticiaChat(
      titulo: n.title,
      resumo: n.snippet,
    );
  }

  static List<NoticiaChat> mapList(List<Noticias> lista) {
    return lista.map(map).toList();
  }
}