import '../entities/corretora.dart';
import '../repositories/corretora_repository.dart';

class GetCorretoras {
  final CorretoraRepository repository;

  GetCorretoras(this.repository);

  List<Corretora> call() {
    return repository.getCorretoras();
  }
}