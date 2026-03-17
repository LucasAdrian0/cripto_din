import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_din/domain/entities/chat_mensage.dart';
import 'package:cripto_din/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore firestore;

  ChatRepositoryImpl({FirebaseFirestore? firestoreInstance})
    : firestore = firestoreInstance ?? FirebaseFirestore.instance;

  @override
  Future<void> salvarMensagem(ChatMessage message) async {
    try {
      await firestore.collection('chat').add({
        'id': message.id,
        'text': message.text,
        'sender': message.sender.name,
        'timestamp': message.timestamp,
      });
    } catch (e) {
      throw Exception("Erro ao salvar mensagem no chat: $e");
    }
  }
}
