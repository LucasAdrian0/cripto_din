import 'package:cripto_din/model/cripto_model.dart';
import 'package:cripto_din/pages/cadastro_usuario.dart/cadastro_usuario.dart';
import 'package:cripto_din/repository/firebase_cripto_repository.dart';
import 'package:cripto_din/service/coingecko_service.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _pesquisarTexto = "";

  final FirebaseCriptoRepository _firebaseService = FirebaseCriptoRepository();
  late final Stream<List<CriptoModel>> _buscarCriptomoedas;

  @override
  void initState() {
    super.initState();
    _buscarCriptomoedas = _firebaseService.getCriptomoedas();
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
          //Lista de Criptomoedas
          Expanded(
            child: StreamBuilder<List<CriptoModel>>(
              stream: _buscarCriptomoedas,
              builder: (context, snapshot) {
                debugPrint("Buscando Criptomoedas do Firebase");
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Erro ao carregar dados"));
                }

                final criptos = snapshot.data ?? [];
                if (criptos.isEmpty) {
                  return const Center(
                    child: Text("Nenhuma criptomoeda encontrada"),
                  );
                }

                // Filtro pelo texto de pesquisa
                final filtroCripto = criptos.where((c) {
                  return c.name.toLowerCase().contains(_pesquisarTexto) ||
                      c.symbol.toLowerCase().contains(_pesquisarTexto);
                }).toList();

                return RefreshIndicator(
                  onRefresh: () async {
                    final lista = await CoingeckoService()
                        .listaDeCriptomoedas();
                    await _firebaseService.salvarCriptomoedas(lista);
                  },
                  child: ListView.builder(
                    itemCount: filtroCripto.length,
                    itemBuilder: (context, index) {
                      final cripto = filtroCripto[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: cripto.image.isNotEmpty
                              ? NetworkImage(cripto.image)
                              : null,
                          child: cripto.image.isEmpty
                              ? const Icon(Icons.currency_bitcoin)
                              : null,
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
                  ),
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
