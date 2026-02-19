import 'package:cripto_din/model/usuario_model.dart';
import 'package:cripto_din/service/usuario_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CabecalhoUsuario extends StatelessWidget {
  const CabecalhoUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final UsuarioService usuarioService = UsuarioService();

    if (user == null) {
      return const CircleAvatar(radius: 18, child: Icon(Icons.person));
    }

    return StreamBuilder<UsuarioModel?>(
      stream: usuarioService.buscarUsuario(user.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircleAvatar(radius: 18, child: Icon(Icons.person));
        }

        final usuario = snapshot.data!;

        return GestureDetector(
          onTap: () {
            // Navegar para tela de cadastro
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage:
                    usuario.foto != null && usuario.foto!.isNotEmpty
                    ? NetworkImage(usuario.foto!)
                    : null,
                child: usuario.foto == null || usuario.foto!.isEmpty
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: 10),
              Text(
                usuario.nome ?? "",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}
