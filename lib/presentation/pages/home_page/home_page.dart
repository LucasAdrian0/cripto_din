import 'package:cripto_din/data/repository/cripto_repository_impl.dart';
import 'package:cripto_din/data/service/coingecko_service_impl.dart';
import 'package:cripto_din/domain/repositories/cripto_repository.dart';
import 'package:cripto_din/presentation/theme/design_tema_controller.dart';
import 'package:cripto_din/presentation/widgets/cabecalho_usuario.dart';
import 'package:cripto_din/presentation/widgets/carrocel_noticias.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_din/domain/entities/cripto.dart';
import 'package:cripto_din/data/repository/noticias_repository_impl.dart';
import 'package:cripto_din/data/service/noticias_service_impl.dart';
import 'package:cripto_din/domain/repositories/noticias_repository.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  String _pesquisarTexto = "";

  late final CriptoRepository repository;
  late final Stream<List<Cripto>> _buscarCriptomoedas;
  late final NoticiasRepository noticiasRepository;

  @override
  void initState() {
    super.initState();

    repository = CriptoRepositoryImpl(
      firestore: FirebaseFirestore.instance,
      service: CoingeckoServiceImpl(),
    );

    _buscarCriptomoedas = repository.getCriptomoedas();

    noticiasRepository = NoticiasRepositoryImpl(
      firestore: FirebaseFirestore.instance,
      service: NoticiasServiceImpl(),
    );

    _carregarNoticias();
  }

  Future<void> _carregarNoticias() async {
    final precisaAtualizar = await noticiasRepository
        .atualizarNoticiasApos15Minuto();

    if (precisaAtualizar) {
      await noticiasRepository.atualizarNoticiasAgora();
    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          //tela de dados do usuário
          title: const CabecalhoUsuario(),

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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Principais Noticias",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          /// CARROSSEL DE NOTÍCIAS
          CarrocelDeNoticias(repository: noticiasRepository),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Criptomoedas",
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
            child: StreamBuilder<List<Cripto>>(
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
                    await repository.atualizarCriptoAgora();
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
