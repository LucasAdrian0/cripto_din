import 'package:cripto_din/data/model/noticias_model.dart';

abstract class NoticiasService {
  Future<List<NoticiasModel>> carrocelDeNoticias();
}
