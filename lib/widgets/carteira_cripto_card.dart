import 'package:flutter/material.dart';
import '../model/carteira_criptomoedas_binance_model.dart';

class CarteiraCriptoCard extends StatelessWidget {
  final CarteiraCriptomoedasBinanceModel carteira;

  const CarteiraCriptoCard({
    super.key,
    required this.carteira,
  });

  @override
  Widget build(BuildContext context) {
    final ativos = carteira.balances
        ?.where((e) =>
            double.parse(e.free ?? '0') > 0 ||
            double.parse(e.locked ?? '0') > 0)
        .toList();

    if (ativos == null || ativos.isEmpty) {
      return const Center(
        child: Text('Nenhum ativo encontrado'),
      );
    }

    return ListView.builder(
      itemCount: ativos.length,
      itemBuilder: (context, index) {
        final cripto = ativos[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.currency_bitcoin),
            title: Text(
              cripto.asset ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Disponível: ${cripto.free}\nBloqueado: ${cripto.locked}',
            ),
          ),
        );
      },
    );
  }
}
