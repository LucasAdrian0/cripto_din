import 'package:cripto_din/model/usuario_model.dart';
import 'package:cripto_din/service/usuario_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CabecalhoUsuario extends StatelessWidget {
  const CabecalhoUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final usuarioService = UsuarioService();

    // Se não estiver logado
    if (user == null) {
      return const CircleAvatar(radius: 18, child: Icon(Icons.person));
    }

    // Usando StreamBuilder para atualizar Firestore se houver mudanças
    return StreamBuilder<UsuarioModel?>(
      stream: usuarioService.buscarUsuario(user.uid),
      builder: (context, snapshot) {
        // Dados do Firestore ainda não carregados
        final usuarioFirestore = snapshot.data;

        // Prioridade: Firestore > FirebaseAuth
        final nome = usuarioFirestore?.nome?.isNotEmpty == true
            ? usuarioFirestore!.nome!
            : user.displayName ?? "Usuário";
        final fotoUrl = usuarioFirestore?.foto?.isNotEmpty == true
            ? usuarioFirestore!.foto
            : user.photoURL;

        return GestureDetector(
          onTap: () {
            // Navegar para perfil ou edição do usuário
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: (fotoUrl != null && fotoUrl.isNotEmpty)
                    ? NetworkImage(fotoUrl)
                    : null,
                child: (fotoUrl == null || fotoUrl.isEmpty)
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: 10),
              Text(nome, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        );
      },
    );
  }
}
