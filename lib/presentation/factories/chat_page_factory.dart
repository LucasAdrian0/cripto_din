import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_din/data/datasources/gemini/noticias_web_datasource_impl.dart';
import 'package:cripto_din/data/repository/chat_repository_impl.dart';
import 'package:cripto_din/presentation/pages/chat/chat_page.dart.dart';
import 'package:dio/dio.dart';
import 'package:cripto_din/data/datasources/gemini/gemini_datasource_impl.dart';
import 'package:cripto_din/data/repository/ia_repository_impl.dart';
import 'package:cripto_din/data/repository/cripto_repository_impl.dart';
import 'package:cripto_din/data/service/coingecko_service_impl.dart';
import 'package:cripto_din/domain/usecases/pergunta_ia.dart';

class ChatPageFactory {
  static ChatPage create() {
    /// CLIENT HTTP
    final dio = Dio();

    /// DATASOURCES
    final geminiDatasource = GeminiDatasourceImpl(dioClient: dio);

    final noticiasWebDatasource = NoticiasWebDatasourceImpl(dioClient: dio);

    /// REPOSITORIES
    final aiRepository = IARepositoryImpl(
      geminiDatasource,
      noticiasWebDatasource,
    );

    final cryptoRepository = CriptoRepositoryImpl(
      firestore: FirebaseFirestore.instance,
      service: CoingeckoServiceImpl(),
    );

    final chatRepository = ChatRepositoryImpl();

    /// USECASE
    final perguntarIA = PerguntarIA(
      aiRepository: aiRepository,
      cryptoRepository: cryptoRepository,
      chatRepository: chatRepository,
    );

    /// PAGE
    return ChatPage(perguntarIA: perguntarIA);
  }
}
