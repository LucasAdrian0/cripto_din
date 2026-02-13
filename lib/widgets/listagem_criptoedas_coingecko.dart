import 'package:cripto_din/service/coingecko_service.dart';
import 'package:cripto_din/service/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:cripto_din/model/cripto_model.dart';

class CryptoList extends StatefulWidget {
  const CryptoList({super.key});

  @override
  State<CryptoList> createState() => _CryptoListState();
}

class _CryptoListState extends State<CryptoList> {
  final FirebaseService _firebaseService = FirebaseService();
  final CoingeckoService _coingeckoService = CoingeckoService();

  @override
  void initState() {
    super.initState();
    _atualizarCriptos();
  }

  /// Busca os dados da API e salva no Firebase
  Future<void> _atualizarCriptos() async {
    try {
      final lista = await _coingeckoService.listaDeCriptomoedas();
      await _firebaseService.salvarCriptomoedasFirebase(lista);
    } catch (e) {
      print("Erro ao atualizar criptos: $e");
    }
  }

  /// Define a cor do avatar por símbolo
  Color _corPorSimbolo(String symbol) {
    switch (symbol.toUpperCase()) {
      case "BTC":
        return Colors.orange;
      case "ETH":
        return Colors.purple;
      case "BNB":
        return Colors.amber;
      case "SOL":
        return Colors.blue;
      case "XRP":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CriptoModel>>(
      stream: _firebaseService.buscarCriptomoedasFirebase(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final lista = snapshot.data!;

        return RefreshIndicator(
          onRefresh: _atualizarCriptos,
          child: ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final cripto = lista[index];
              final cor = _corPorSimbolo(cripto.symbol);

              // Formata o valor da variação de preço
              final change = cripto.change24h.toStringAsFixed(2);
              final changeText =
                  (cripto.change24h >= 0 ? '+' : '') + change + '%';

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: cor,
                  child: Text(cripto.symbol[0].toUpperCase()),
                ),
                title: Text("${cripto.name} (${cripto.symbol.toUpperCase()})"),
                subtitle: Text("US\$ ${cripto.price.toStringAsFixed(2)}"),
                trailing: Text(
                  changeText,
                  style: TextStyle(
                    color: cripto.change24h >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
