import 'package:dio/dio.dart';
import 'package:cripto_din/data/datasources/noticias_web_datasource.dart';
import 'package:cripto_din/domain/entities/noticia_chat.dart';

class NoticiasWebDatasourceImpl implements NoticiasWebDatasource {
  final Dio dio;

  NoticiasWebDatasourceImpl({Dio? dioClient})
      : dio = dioClient ?? Dio();

  @override
  Future<List<NoticiaChat>> buscarNoticias() async {
    try {
      //BUSCA DIRETO DO GOOGLE NEWS (SEM API)
      final response = await dio.get(
        "https://news.google.com/rss/search?q=criptomoedas&hl=pt-BR&gl=BR&ceid=BR:pt-419",
      );

      final xml = response.data.toString();

      //EXTRAÇÃO SIMPLES DOS TÍTULOS DO RSS
      final regex = RegExp(r'<title>(.*?)<\/title>');
      final matches = regex.allMatches(xml).toList();

      //remove primeiro título (é o canal)
      final noticias = matches.skip(1).take(5).map((match) {
        final titulo = match.group(1) ?? '';

        return NoticiaChat(
          titulo: titulo,
          resumo: '',
        );
      }).toList();

      return noticias;
    } catch (e) {
      throw Exception("Erro ao buscar notícias da internet: $e");
    }
  }
}