import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_din/data/mapper/cripto_mapper.dart';
import 'package:cripto_din/data/model/cripto_model.dart';
import 'package:cripto_din/data/repository/cripto_repository.dart';
import 'package:cripto_din/data/service/coingecko_service.dart';
import 'package:flutter/material.dart';

class FirebaseCriptoRepository implements CriptoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// SALVAR LISTA DE CRIPTOS NO FIREBASE
  @override
  Future<void> salvarCriptomoedas(List<CriptoModel> lista) async {
    final batch = _firestore.batch();

    for (var cripto in lista) {
      final docRef = _firestore.collection('criptomoedas').doc(cripto.id);
      batch.set(docRef, CriptoMapper.toMap(cripto));
    }

    //fiz para controllar a atualização de cripto
    final controleRef = _firestore.collection('controle').doc('atualizacao');
    batch.set(controleRef, {'ultimaAtualizacao': FieldValue.serverTimestamp()});

    await batch.commit();
  }

  /// Listar Criptomoedas por ordem descendente de preço
  @override
  Stream<List<CriptoModel>> getCriptomoedas() {
    return _firestore
        .collection('criptomoedas')
        .orderBy('price', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CriptoMapper.fromMap(doc.data()))
              .toList(),
        );
  }

  //atualizar Apos 1 Hora?
  @override
  Future<bool> atualizarApos1Minuto() async {
    final snapshot = await _firestore.collection('criptomoedas').limit(1).get();

    if (snapshot.docs.isEmpty) return true;

    final doc = await _firestore
        .collection('controle')
        .doc('atualizacao')
        .get();

    if (!doc.exists) return true;

    final timestamp = doc.data()?['ultimaAtualizacao'] as Timestamp?;

    if (timestamp == null) return true;

    final ultimaAtualizacao = timestamp.toDate();
    final agora = DateTime.now();

    return agora.difference(ultimaAtualizacao).inMinutes >= 1;
  }

  /// Atualiza imediatamente as criptomoedas no Firebase
  @override
  Future<List<CriptoModel>> atualizarAgora() async {
    try {
      debugPrint("Atualizando criptos agora...");

      // Buscar da API
      final lista = await CoingeckoService().listaDeCriptomoedas();
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
