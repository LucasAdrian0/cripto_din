import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_din/model/usuario_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsuarioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUser(User user) async {
    final docRef = _firestore.collection('usuarios').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final newUser = UsuarioModel(
        nome: user.displayName ?? '',
        email: user.email ?? '',
        foto: user.photoURL ?? '',
        apiKey: '',
        secretKey: '',
      );

      await docRef.set(newUser.toJson());
    }
  }
  
}
