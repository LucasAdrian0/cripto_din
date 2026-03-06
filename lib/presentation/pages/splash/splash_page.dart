import 'package:cripto_din/presentation/pages/home/home_page.dart';
import 'package:cripto_din/data/service/coingecko_service_impl.dart';
import 'package:cripto_din/data/repository/cripto_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final CoingeckoServiceImpl _coingeckoService = CoingeckoServiceImpl();

  late final CriptoRepositoryImpl _firebaseService = CriptoRepositoryImpl(
    firestore: FirebaseFirestore.instance,
    service: _coingeckoService,
  );

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    Future.microtask(() async {
      try {
        final precisa = await _firebaseService.atualizarCriptoApos1Minuto();

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
