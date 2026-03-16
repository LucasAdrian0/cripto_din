
enum ChatMessageSender { user, ia }

class ChatMessage {
  final String id; // ID único da mensagem
  final String text; // conteúdo da mensagem
  final ChatMessageSender sender; // quem enviou
  final DateTime timestamp; // momento do envio

  ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
  });
}
