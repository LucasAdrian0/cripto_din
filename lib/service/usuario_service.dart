import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_din/model/usuario_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Responsabilidade:
class UsuarioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> salvarUsuario(User user) async {
    final docRef = _firestore.collection('usuario').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final usuario = UsuarioModel(
        nome: user.displayName ?? '',
        email: user.email ?? '',
        foto: user.photoURL,
        apiKey: '',
        secretKey: '',
      );

      await docRef.set(usuario.toMap());
    }
  }

  /// BUSCAR USUARIO NO FIREBASE
  Stream<UsuarioModel?> buscarUsuario(String uid) {
    return _firestore.collection('usuario').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UsuarioModel.fromMap(doc.data()!);
      }
      return null;
    });
  }
}
