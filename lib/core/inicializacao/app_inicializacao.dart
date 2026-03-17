import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_din/data/repository/noticias_repository_impl.dart';
import 'package:cripto_din/data/service/noticias_service_impl.dart';

class AppInicializacao {
  static Future<void> inicializar() async {
    final repository = NoticiasRepositoryImpl(
      firestore: FirebaseFirestore.instance,
      service: NoticiasServiceImpl(),
    );

    if (await repository.atualizarNoticiasApos30Minuto()) {
      await repository.atualizarNoticiasAgora();
    }
  }
}
