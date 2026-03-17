import 'package:cripto_din/data/datasources/gemini/gemini_datasource.dart';
import 'package:cripto_din/data/datasources/noticias_web_datasource.dart';
import 'package:cripto_din/domain/entities/cripto.dart';
import 'package:cripto_din/domain/entities/noticia_chat.dart';
import 'package:cripto_din/domain/repositories/ia_repository.dart';

class IARepositoryImpl implements IARepository {
  final GeminiDatasource datasource;
  final NoticiasWebDatasource noticiasDatasource;

  IARepositoryImpl(
    this.datasource,
    this.noticiasDatasource,
  );

  @override
  Future<String> gerarResposta({
    required String pergunta,
    required List<Cripto> criptos,
  }) async {
    try {
      //BUSCA NOTÍCIAS DA INTERNET
      final List<NoticiaChat> noticias =
          await noticiasDatasource.buscarNoticias();

      //ENVIA PARA IA
      final resposta = await datasource.perguntarIA(
        pergunta: pergunta,
        criptos: criptos,
        noticias: noticias,
      );

      return resposta;
    } catch (e) {
      throw Exception("Falha ao gerar resposta da IA: $e");
    }
  }
}