import 'package:cripto_din/data/model/usuario_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UsuarioService {
  Future<void> salvarUsuario(User user);
  Stream<UsuarioModel?> buscarUsuario(String uid);
}
