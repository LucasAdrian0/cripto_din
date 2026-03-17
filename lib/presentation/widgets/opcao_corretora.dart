import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

/*
ABRIR URL DENTRO DO APP
(Custom Tabs / Safari View)
*/
Future<void> _abrirNoApp(BuildContext context, String url) async {
  try {
    await launchUrl(
      Uri.parse(url),
      customTabsOptions: const CustomTabsOptions(
        showTitle: true,
        shareState: CustomTabsShareState.off,
      ),
      safariVCOptions: const SafariViewControllerOptions(
        preferredBarTintColor: Colors.black,
        preferredControlTintColor: Colors.white,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Não foi possível abrir a corretora.")),
    );
  }
}

void abrirOpcoesCorretora(BuildContext context, String nome, String url) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Título
            Text(
              nome,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            /// Abrir site
            ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: const Text("Abrir site"),
              onTap: () async {
                Navigator.pop(context);
                await _abrirNoApp(context, url);
              },
            ),

            /// Criar conta
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text("Criar conta"),
              onTap: () async {
                Navigator.pop(context);
                await _abrirNoApp(context, url);
              },
            ),

            /// Login
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text("Login"),
              onTap: () async {
                Navigator.pop(context);
                await _abrirNoApp(context, url);
              },
            ),
          ],
        ),
      );
    },
  );
}
