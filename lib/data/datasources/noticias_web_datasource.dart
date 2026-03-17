import '../../domain/entities/noticia_chat.dart';

abstract class NoticiasWebDatasource {
  Future<List<NoticiaChat>> buscarNoticias();
}