import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void abrirOpcoesCorretora(
  BuildContext context,
  String nome,
  String url,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              nome,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: const Text("Abrir site"),
              onTap: () async {
                Navigator.pop(context);
                final uri = Uri.parse(url);
                await launchUrl(uri,
                    mode: LaunchMode.externalApplication);
              },
            ),

            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text("Criar conta"),
              onTap: () async {
                Navigator.pop(context);
                final uri = Uri.parse(url);
                await launchUrl(uri,
                    mode: LaunchMode.externalApplication);
              },
            ),

            ListTile(
              leading: const Icon(Icons.login),
              title: const Text("Login"),
              onTap: () async {
                Navigator.pop(context);
                final uri = Uri.parse(url);
                await launchUrl(uri,
                    mode: LaunchMode.externalApplication);
              },
            ),
          ],
        ),
      );
    },
  );
}