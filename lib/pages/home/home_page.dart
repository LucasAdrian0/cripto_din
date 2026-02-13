import 'package:cripto_din/service/coingecko_service.dart';
import 'package:cripto_din/service/firebase_service.dart';
import 'package:cripto_din/theme/design_tema_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    _atualizarCriptos();
  }

  final CoingeckoService _coingeckoService = CoingeckoService();
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _atualizarCriptos() async {
    try {
      final lista = await _coingeckoService.listaDeCriptomoedas();
      await _firebaseService.salvarCriptomoedasFirebase(lista);
    } catch (e) {
      print("Erro ao atualizar criptos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: const Text('Usuário'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () => context.read<ThemeController>().toggleTheme(),
              icon: Icon(
                context.watch<ThemeController>().isDark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// CARROSSEL DE NOTÍCIAS
          SizedBox(
            height: 200,
            child: PageView(
              children: [
                newsCard(
                  "Bitcoin sobe 8%",
                  "Mercado reage após nova alta institucional",
                  Colors.orange,
                ),
                newsCard(
                  "Ethereum ETF aprovado",
                  "Investidores otimistas com novo produto",
                  Colors.purple,
                ),
                newsCard(
                  "Solana dispara 12%",
                  "Volume aumenta nas últimas 24h",
                  Colors.blue,
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Principais Criptomoedas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          /// LISTA DE CRIPTOS
          Expanded(
            child: ListView(
              children: [
                cryptoTile("Bitcoin", "BTC", "62.450", "+2.3%", Colors.orange),
                cryptoTile("Ethereum", "ETH", "3.420", "-1.1%", Colors.purple),
                cryptoTile("BNB", "BNB", "580", "+0.8%", Colors.amber),
                cryptoTile("Solana", "SOL", "145", "-4.7%", Colors.blue),
                cryptoTile("XRP", "XRP", "0.62", "-0.5%", Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget newsCard(String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(subtitle, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget cryptoTile(
    String name,
    String symbol,
    String price,
    String change,
    Color color,
  ) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: color, child: Text(symbol[0])),
      title: Text("$name ($symbol)"),
      subtitle: Text("US\$ $price"),
      trailing: Text(
        change,
        style: TextStyle(
          color: change.contains('+') ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
// falta chamar a api que salva no firebasee chama do fire passe para a home
/*
exemplo para chamada
  Expanded(
  child: const CryptoList(),
),
*/