import 'package:cripto_din/domain/entities/noticias.dart';

abstract class AtualizarNoticiasUseCase {
  Future<List<Noticias>> call();
}
