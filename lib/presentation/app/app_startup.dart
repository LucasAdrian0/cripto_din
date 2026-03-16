import 'package:cripto_din/core/inicializacao/app_inicializacao.dart';
import 'package:flutter/material.dart';
import '../navigation/app_tab_navigation_widget.dart';
import '../navigation/app_tabs_config.dart';

class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await AppInicializacao.inicializar();

    if (mounted) {
      setState(() => _initialized = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return TabNavigationWidget(
      tabs: AppTabsConfig.tabs,
    );
  }
}