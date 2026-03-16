import 'package:cripto_din/domain/entities/noticias.dart';

abstract class NoticiasRepository {
  Future<void> salvarNoticias(List<Noticias> noticias);
  Stream<List<Noticias>> buscarNoticias();
  Future<bool> atualizarNoticiasApos30Minuto();
  Future<List<Noticias>> atualizarNoticiasAgora();
}
