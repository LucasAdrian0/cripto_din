import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_din/model/cripto_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //SALVAR CRIPTOS NO FIREBASE
  Future<void> salvarCriptomoedasFirebase(List<CriptoModel> lista) async {
    final batch = _firestore.batch();

    for (var cripto in lista) {
      final docRef = _firestore.collection('criptomoedas').doc(cripto.id);

      batch.set(docRef, cripto.toMap());
    }

    await batch.commit();
  }

  //BUSCAR CRIPTOS
  Stream<List<CriptoModel>> buscarCriptomoedasFirebase() {
    return _firestore
        .collection('criptomoedas')
        .orderBy('price', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CriptoModel.fromMap(doc.data()))
              .toList(),
        );
  }
}
