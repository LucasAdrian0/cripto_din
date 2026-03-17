import 'package:cripto_din/domain/entities/noticia_chat.dart';

abstract class IANoticiasRepository {
  Future<List<NoticiaChat>> buscarNoticiasRecentes();
}
