import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NoticiaWebView extends StatefulWidget {
  final String url;

  const NoticiaWebView({super.key, required this.url});

  @override
  State<NoticiaWebView> createState() => _NoticiaWebViewState();
}

class _NoticiaWebViewState extends State<NoticiaWebView> {

  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notícia"),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}