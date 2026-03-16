import 'package:cripto_din/domain/entities/chat_mensage.dart';
import 'package:cripto_din/domain/repositories/chat_repository.dart';
import 'package:cripto_din/domain/repositories/cripto_repository.dart';
import 'package:cripto_din/domain/repositories/ia_noticias_repository.dart';
import 'package:cripto_din/domain/repositories/ia_repository.dart';
import 'package:flutter/material.dart';

class PerguntarIA {
  final AIRepository aiRepository;
  final CriptoRepository cryptoRepository;
  final IANoticiasRepository noticiasRepository;
  final ChatRepository chatRepository;

  PerguntarIA({
    required this.aiRepository,
    required this.cryptoRepository,
    required this.noticiasRepository,
    required this.chatRepository,
  });

  Future<String> call(String pergunta) async {
    // 1️⃣ Busca criptos do Firebase e converte o Stream para List
    final criptosList = await cryptoRepository.getCriptomoedas().first;

    // 2️⃣ Busca notícias da internet
    final noticias = await noticiasRepository.buscarNoticiasRecentes();

    // 3️⃣ Pergunta à IA passando os dados corretos
    final resposta = await aiRepository.gerarResposta(
      pergunta: pergunta,
      criptos: criptosList,
      noticias: noticias,
    );

    // 4️⃣ Salva histórico de chat - usuário
    await chatRepository.salvarMensagem(ChatMessage(
      id: UniqueKey().toString(),
      text: pergunta,
      sender: ChatMessageSender.user,
      timestamp: DateTime.now(),
    ));

    // 5️⃣ Salva histórico de chat - IA
    await chatRepository.salvarMensagem(ChatMessage(
      id: UniqueKey().toString(),
      text: resposta,
      sender: ChatMessageSender.ia,
      timestamp: DateTime.now(),
    ));

    return resposta;
  }
}