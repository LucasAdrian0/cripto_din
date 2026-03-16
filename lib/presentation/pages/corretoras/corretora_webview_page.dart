import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CorretoraWebViewPage extends StatefulWidget {
  final String url;
  final String nome;

  const CorretoraWebViewPage({
    super.key,
    required this.url,
    required this.nome,
  });

  @override
  State<CorretoraWebViewPage> createState() => _CorretoraWebViewPageState();
}

class _CorretoraWebViewPageState extends State<CorretoraWebViewPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nome),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}