import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_din/data/mapper/noticias_mapper.dart';
import 'package:cripto_din/data/model/noticias_model.dart';
import 'package:cripto_din/domain/entities/noticias.dart';
import 'package:cripto_din/domain/repositories/noticias_repository.dart';
import 'package:cripto_din/domain/services/noticias_service.dart';
import 'package:flutter/material.dart';

class NoticiasRepositoryImpl implements NoticiasRepository {
  final FirebaseFirestore firestore;
  final NoticiasService service;

  NoticiasRepositoryImpl({required this.firestore, required this.service});

  /// SALVAR LISTA DE NOTICIAS NO FIREBASE
  @override
  Future<void> salvarNoticias(List<Noticias> noticias) async {
    final batch = firestore.batch();

    for (var noticia in noticias) {
      final model = NoticiasModel.fromEntity(noticia);

      final docRef = firestore.collection('noticias').doc(model.uuid);

      batch.set(docRef, NoticiasMapper.toMap(model));
    }

    final controleRef = firestore
        .collection('controle')
        .doc('atualizacaoDeNoticias');

    batch.set(controleRef, {'ultimaAtualizacao': FieldValue.serverTimestamp()});

    await batch.commit();
  }

  /// Listar Noticias por ordem descendente de preço
  @override
  Stream<List<Noticias>> getNoticias() {
    return firestore
        .collection('noticias')
        .orderBy('publishedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NoticiasMapper.fromMap(doc.data()).toEntity())
              .toList(),
        );
  }

  //atualizar Apos 15 minuto
  @override
  Future<bool> atualizarNoticiasApos15Minuto() async {
    final snapshot = await firestore.collection('noticias').limit(3).get();

    if (snapshot.docs.isEmpty) return true;

    final doc = await firestore
        .collection('controle')
        .doc('atualizacaoDeNoticias')
        .get();

    if (!doc.exists) return true;

    final timestamp = doc.data()?['ultimaAtualizacao'] as Timestamp?;

    if (timestamp == null) return true;

    final ultimaAtualizacao = timestamp.toDate();
    final agora = DateTime.now();

    return agora.difference(ultimaAtualizacao).inMinutes >= 15;
  }

  /// Atualiza imediatamente as criptomoedas no Firebase
  @override
  Future<List<Noticias>> atualizarNoticiasAgora() async {
    try {
      debugPrint("Atualizando noticias agora...");

      // Buscar da API
      final lista = await service.carrocelDeNoticias();
      //Salvar em batch no Firebase
      final batch = FirebaseFirestore.instance.batch();
      final collection = FirebaseFirestore.instance.collection('noticias');

      for (var noticia in lista) {
        final docRef = collection.doc(noticia.uuid);
        batch.set(docRef, NoticiasMapper.toMap(noticia));
      }

      // Atualizar timestamp de controle
      final controleRef = FirebaseFirestore.instance
          .collection('controle')
          .doc('atualizacaoDeNoticias');
      batch.set(controleRef, {
        'ultimaAtualizacao': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      debugPrint("Atualização concluída: ${lista.length} noticias.");
      return lista;
    } catch (e) {
      debugPrint("Erro ao atualizar noticias: $e");
      return [];
    }
  }
}
