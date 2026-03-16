import 'package:cripto_din/data/mapper/noticias_to_chat_mapper.dart';

abstract class IANoticiasRepository {
  Future<List<NoticiaToChatMapper>> buscarNoticiasRecentes();
}