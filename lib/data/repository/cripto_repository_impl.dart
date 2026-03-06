import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_din/data/mapper/cripto_mapper.dart';
import 'package:cripto_din/data/model/cripto_model.dart';
import 'package:cripto_din/domain/entities/cripto.dart';
import 'package:cripto_din/domain/repositories/cripto_repository.dart';
import 'package:cripto_din/data/service/coingecko_service_impl.dart';
import 'package:cripto_din/domain/services/coingecko_service.dart';
import 'package:flutter/material.dart';

class CriptoRepositoryImpl implements CriptoRepository {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore firestore;
  final CoingeckoService service;

  CriptoRepositoryImpl({required this.firestore, required this.service});

  /// SALVAR LISTA DE CRIPTOS NO FIREBASE
  @override
  Future<void> salvarCriptomoedas(List<Cripto> lista) async {
    final batch = firestore.batch();

    for (var cripto in lista) {
      final model = CriptoModel.fromEntity(cripto);

      final docRef = firestore.collection('criptomoedas').doc(model.id);
      batch.set(docRef, CriptoMapper.toMap(model));
    }

    //fiz para controllar a atualização de cripto
    final controleRef = firestore.collection('controle').doc('atualizacao');
    batch.set(controleRef, {'ultimaAtualizacao': FieldValue.serverTimestamp()});

    await batch.commit();
  }

  /// Listar Criptomoedas por ordem descendente de preço
  @override
  Stream<List<Cripto>> getCriptomoedas() {
    return firestore
        .collection('criptomoedas')
        .orderBy('price', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CriptoMapper.fromMap(doc.data()).toEntity())
              .toList(),
        );
  }

  //atualizar Apos 1 minuto
  @override
  Future<bool> atualizarCriptoApos1Minuto() async {
    final snapshot = await firestore.collection('criptomoedas').limit(1).get();

    if (snapshot.docs.isEmpty) return true;

    final doc = await firestore.collection('controle').doc('atualizacao').get();

    if (!doc.exists) return true;

    final timestamp = doc.data()?['ultimaAtualizacao'] as Timestamp?;

    if (timestamp == null) return true;

    final ultimaAtualizacao = timestamp.toDate();
    final agora = DateTime.now();

    return agora.difference(ultimaAtualizacao).inMinutes >= 1;
  }

  /// Atualiza imediatamente as criptomoedas no Firebase
  @override
  Future<List<CriptoModel>> atualizarCriptoAgora() async {
    try {
      debugPrint("Atualizando criptos agora...");

      // Buscar da API
      final lista = await CoingeckoServiceImpl().listaDeCriptomoedas();
      //Salvar em batch no Firebase
      final batch = FirebaseFirestore.instance.batch();
      final collection = FirebaseFirestore.instance.collection('criptomoedas');

      for (var cripto in lista) {
        final docRef = collection.doc(cripto.id);
        batch.set(docRef, CriptoMapper.toMap(cripto));
      }

      // Atualizar timestamp de controle
      final controleRef = FirebaseFirestore.instance
          .collection('controle')
          .doc('atualizacao');
      batch.set(controleRef, {
        'ultimaAtualizacao': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      debugPrint("Atualização concluída: ${lista.length} criptomoedas.");
      return lista;
    } catch (e) {
      debugPrint("Erro ao atualizar criptos: $e");
      return [];
    }
  }
}
