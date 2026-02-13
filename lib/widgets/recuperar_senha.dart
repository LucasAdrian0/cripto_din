import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecuperarSenhaButton extends StatelessWidget {
  const RecuperarSenhaButton({super.key});

  Future<void> _DialogRecuperarSenha(BuildContext context) async {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Recuperar senha"),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: "Digite seu email",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.sendPasswordResetEmail(
                email: emailController.text.trim(),
              );

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Email enviado com sucesso!"),
                ),
              );
            },
            child: const Text("Enviar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _DialogRecuperarSenha(context),
      child: const Text("Esqueci minha senha"),
    );
  }
}
