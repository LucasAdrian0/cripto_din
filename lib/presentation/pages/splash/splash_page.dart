import 'package:cripto_din/data/repository/noticias_repository_impl.dart';
import 'package:cripto_din/data/service/noticias_service_impl.dart';
import 'package:cripto_din/domain/services/noticias_service.dart';
import 'package:cripto_din/presentation/pages/home_page/home_page.dart';
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
  //SERVICES
  final CoingeckoServiceImpl _coingeckoService = CoingeckoServiceImpl();
  final NoticiasService _noticiasService = NoticiasServiceImpl();

  //REPOSITORIES
  late final CriptoRepositoryImpl _firebaseService = CriptoRepositoryImpl(
    firestore: FirebaseFirestore.instance,
    service: _coingeckoService,
  );
  late final NoticiasRepositoryImpl _noticiasRepository =
      NoticiasRepositoryImpl(
        firestore: FirebaseFirestore.instance,
        service: _noticiasService,
      );

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    // Verificar e atualizar notícias
    Future.microtask(() async {
      try {
        final precisa = await _noticiasRepository
            .atualizarNoticiasApos15Minuto();

        if (precisa) {
          debugPrint("Atualizando notícias...");

          final lista = await _noticiasService.carrocelDeNoticias();
          await _noticiasRepository.salvarNoticias(lista);

          debugPrint("Atualização de notícias concluída.");
          debugPrint("atualizado ${lista.length} notícias");
          debugPrint(lista.map((e) => e.title).toList().toString());
        } else {
          debugPrint("Ainda dentro dos 15 minutos. Não atualizando notícias.");
        }
      } catch (e) {
        debugPrint("Erro ao atualizar notícias na Splash: $e");
      }
    });

    // Verificar e atualizar criptomoedas
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
