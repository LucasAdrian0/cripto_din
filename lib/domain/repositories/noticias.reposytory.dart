import 'package:cripto_din/domain/entities/noticias.dart';

abstract class NoticiasRepository {
  Stream<List<Noticias>> getNoticias();
  Future<void> salvarNoticias(List<Noticias> noticias);
  Future<bool> atualizarNoticiasApos15Minuto();
  Future<List<Noticias>> atualizarNoticiasAgora();
}
