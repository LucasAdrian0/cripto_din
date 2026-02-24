import 'package:cripto_din/pages/home/home_page.dart';
import 'package:cripto_din/service/coingecko_service.dart';
import 'package:cripto_din/repository/firebase_cripto_repository.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final CoingeckoService _coingeckoService = CoingeckoService();
  final FirebaseCriptoRepository _firebaseService = FirebaseCriptoRepository();

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    Future.microtask(() async {
      try {
        final precisa = await _firebaseService.atualizarApos1Hora();

        if (precisa) {
          debugPrint("Atualizando criptos...");

          final lista = await _coingeckoService.listaDeCriptomoedas();
          await _firebaseService.salvarCriptomoedas(lista);

          debugPrint("Atualização concluída.");
          debugPrint("atualizado ${lista.length} criptomoedas");
        } else {
          debugPrint("Ainda dentro da 1 hora. Não atualizando.");
        }
      } catch (e) {
        debugPrint("Erro na Splash: $e");
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Homepage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
