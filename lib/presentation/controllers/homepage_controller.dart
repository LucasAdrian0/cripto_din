import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/cripto.dart';
import '../../domain/repositories/cripto_repository.dart';
import '../../domain/repositories/noticias_repository.dart';

import '../../data/repository/cripto_repository_impl.dart';
import '../../data/repository/noticias_repository_impl.dart';
import '../../data/service/coingecko_service_impl.dart';
import '../../data/service/noticias_service_impl.dart';

class HomepageController extends ChangeNotifier {
  late final CriptoRepository criptoRepository;
  late final NoticiasRepository noticiasRepository;
  late final Stream<List<Cripto>> criptosStream;

  bool _initialized = false;

  HomepageController() {
    _setup();
  }

  void _setup() {
    criptoRepository = CriptoRepositoryImpl(
      firestore: FirebaseFirestore.instance,
      service: CoingeckoServiceImpl(),
    );

    noticiasRepository = NoticiasRepositoryImpl(
      firestore: FirebaseFirestore.instance,
      service: NoticiasServiceImpl(),
    );

    criptosStream = criptoRepository.getCriptomoedas();

    _initAsync();
  }

  Future<void> _initAsync() async {
    if (_initialized) return;
    _initialized = true;

    await _carregarNoticias();
  }

  Future<void> _carregarNoticias() async {
    final precisa =
        await noticiasRepository.atualizarNoticiasApos30Minuto();

    if (precisa) {
      await noticiasRepository.atualizarNoticiasAgora();
    }
  }

  Future<void> refreshCriptos() async {
    await criptoRepository.atualizarCriptoAgora();
  }
}