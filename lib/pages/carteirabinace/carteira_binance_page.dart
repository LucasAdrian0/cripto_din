import 'package:cripto_din/model/carteira_criptomoedas_binance_model.dart';
import 'package:cripto_din/repository/carteira_binance_repository.dart';
import 'package:cripto_din/widgets/carteira_cripto_card.dart';
import 'package:flutter/material.dart';

class CarteiraPage extends StatefulWidget {
  const CarteiraPage({super.key});

  @override
  State<CarteiraPage> createState() => _CarteiraPageState();
}

class _CarteiraPageState extends State<CarteiraPage> {
  late Future<CarteiraCriptomoedasBinanceModel> _futureCarteira;
  final _service = CarteiraBinanceRepository();

  @override
  void initState() {
    super.initState();

    _futureCarteira = _service.buscarCarteira(
      apiKey:
          'SUA_API_KEY', //FAZER DEPOIS - PEGAR DO BANCO DE DADOS DO USUÁRIO LOGADO
      secretKey:
          'SECRET_NO_BACKEND', //FAZER DEPOIS - PEGAR DO BANCO DE DADOS DO USUÁRIO LOGADO
      timestamp: DateTime.now().millisecondsSinceEpoch,
      signature:
          'ASSINATURA_GERADA', // FAZER DEPOIS - GERAR ASSINATURA COM BASE NAS CHAVES E TIMESTAMP
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carteira Binance')),
      body: FutureBuilder<CarteiraCriptomoedasBinanceModel>(
        future: _futureCarteira,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar carteira'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Nenhum dado encontrado'));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: CarteiraCriptoCard(carteira: snapshot.data!),
          );
        },
      ),
    );
  }
}
