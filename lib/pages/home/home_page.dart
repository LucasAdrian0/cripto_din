import 'package:cripto_din/pages/cadastro_usuario.dart/cadastro_usuario.dart';
import 'package:cripto_din/service/coingecko_service.dart';
import 'package:cripto_din/service/firebase_service.dart';
import 'package:cripto_din/service/usuario_service.dart';
import 'package:cripto_din/theme/design_espacamentos.dart';
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

  final TextEditingController _searchController = TextEditingController();
  String _pesquisarTexto = "";

  final CoingeckoService _coingeckoService = CoingeckoService();
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _atualizarCriptos() async {
    try {
      debugPrint("Buscando criptomoedas no coingecko");
      final lista = await _coingeckoService.listaDeCriptomoedas();
      debugPrint("Recebido ${lista.length} criptomoedas da API");
      await _firebaseService.salvarCriptomoedasFirebase(lista);
      debugPrint("salvando criptomoedas no firebase");
    } catch (e) {
      debugPrint("Erro ao atualizar criptos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        //tela de dados do usuário
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CadastroUsuario()),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  "", // foto real
                ),
              ),
              const SizedBox(width: 10),
              DesignEspacamentos.verticalPequeno,
            ],
          ),
        ),

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
          /// CARROSSEL DE NOTÍCIAS - procurar uma api de noticias de cripto
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

          //Pesquisar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Buscar criptomoeda...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _pesquisarTexto = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _firebaseService.buscarCriptomoedasFirebase(),
              builder: (context, snapshot) {
                debugPrint("Buscando Criptomoedas do Firebase");
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Erro ao carregar dados"));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("Nenhuma criptomoeda encontrada"),
                  );
                }

                final criptos = snapshot.data!;
                final filtroCripto = criptos.where((cripto) {
                  return cripto.name.toLowerCase().contains(_pesquisarTexto) ||
                      cripto.symbol.toLowerCase().contains(_pesquisarTexto);
                }).toList();

                return ListView.builder(
                  itemCount: filtroCripto.length,
                  itemExtent: 72,
                  itemBuilder: (context, index) {
                    final cripto = filtroCripto[index];

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(cripto.image),
                      ),
                      title: Text(
                        "${cripto.name} (${cripto.symbol.toUpperCase()})",
                      ),
                      subtitle: Text("R\$ ${cripto.price}"),
                      trailing: Text(
                        "${cripto.change24h.toStringAsFixed(2)}%",
                        style: TextStyle(
                          color: cripto.change24h >= 0
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              },
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
