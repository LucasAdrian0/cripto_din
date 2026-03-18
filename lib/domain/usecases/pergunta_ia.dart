import 'package:cripto_din/domain/entities/chat_mensage.dart';
import 'package:cripto_din/domain/entities/cripto.dart';
import 'package:cripto_din/domain/repositories/chat_repository.dart';
import 'package:cripto_din/domain/repositories/cripto_repository.dart';
import 'package:cripto_din/domain/repositories/ia_repository.dart';
import 'package:flutter/material.dart';

class PerguntarIA {
  final IARepository aiRepository;
  final CriptoRepository cryptoRepository;
  final ChatRepository chatRepository;

  PerguntarIA({
    required this.aiRepository,
    required this.cryptoRepository,
    required this.chatRepository,
  });

  Future<String> call(String pergunta) async {
    //Busca criptos do Firebase (tempo real)  
    final criptosStream = cryptoRepository.getCriptomoedas();

    List<Cripto> criptosList = [];

    try {
      criptosList = await criptosStream.first.timeout(
        const Duration(seconds: 5),
      );
    } catch (e) {
      debugPrint("Erro ao buscar criptos: $e");
    }
    //Pergunta para IA
    final resposta = await aiRepository.gerarResposta(
      pergunta: pergunta,
      criptos: criptosList,
    );

    //Salva mensagem do usuário
    await chatRepository.salvarMensagem(
      ChatMessage(
        id: UniqueKey().toString(),
        text: pergunta,
        sender: ChatMessageSender.user,
        timestamp: DateTime.now(),
      ),
    );

    //Salva resposta da IA
    await chatRepository.salvarMensagem(
      ChatMessage(
        id: UniqueKey().toString(),
        text: resposta,
        sender: ChatMessageSender.ia,
        timestamp: DateTime.now(),
      ),
    );

    return resposta;
  }
}
