
import 'package:cripto_din/domain/entities/chat_mensage.dart';

abstract class ChatRepository {
  Future<void> salvarMensagem(ChatMessage message);
}