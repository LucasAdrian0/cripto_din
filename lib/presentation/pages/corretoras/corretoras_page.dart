import 'package:cripto_din/presentation/widgets/opcao_corretora.dart';
import 'package:flutter/material.dart';
import 'package:cripto_din/data/repository/corretora_repository_impl.dart';
import 'package:cripto_din/domain/usecases/get_corretora.dart';

class CorretorasPage extends StatelessWidget {
  CorretorasPage({super.key});

  final GetCorretoras getCorretoras = GetCorretoras(CorretoraRepositoryImpl());

  @override
  Widget build(BuildContext context) {
    final corretoras = getCorretoras();

    return Scaffold(
      appBar: AppBar(title: const Text("Corretoras")),
      body: ListView.builder(
        itemCount: corretoras.length,
        itemBuilder: (context, index) {
          final corretora = corretoras[index];

          return InkWell(
            onTap: () {
              abrirOpcoesCorretora(context, corretora.nome, corretora.url);
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      corretora.nome,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(Icons.open_in_new),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
