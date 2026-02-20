import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_din/model/usuario_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Responsabilidade: USuário no Firebase(buscar e salva)
class UsuarioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> salvarUsuario(User user) async {
    final docRef = _firestore.collection('usuario').doc(user.uid);

    final usuario = UsuarioModel(
      nome: user.displayName ?? '',
      email: user.email ?? '',
      foto: user.photoURL,
      apiKey: '',
      secretKey: '',
    );

    await docRef.set(usuario.toMap(), SetOptions(merge: true));
  }

  /// BUSCAR USUARIO NO FIREBASE
  Stream<UsuarioModel?> buscarUsuario(String uid) {
    return _firestore.collection('usuario').doc(uid).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return UsuarioModel.fromMap(doc.data()!);
      }
      return null;
    });
  }
}
