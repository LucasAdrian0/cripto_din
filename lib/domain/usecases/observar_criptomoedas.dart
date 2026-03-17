import '../entities/cripto.dart';
import '../repositories/cripto_repository.dart';

class ObservarCriptomoedas {
  final CriptoRepository repository;

  ObservarCriptomoedas(this.repository);

  Stream<List<Cripto>> call() {
    return repository.getCriptomoedas();
  }
}