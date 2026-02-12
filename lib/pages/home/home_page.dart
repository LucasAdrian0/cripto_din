import 'package:cripto_din/pages/cadastro_usuario.dart/cadastro_usuario.dart';
import 'package:cripto_din/theme/designer_espacamentos.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CadastroUsuario(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.person, color: Colors.blue),
                      ),
                    ),
                  ),
                  DesignerEspacamentos.w8,
                  Text("Nome do Usuário"),
                ],
              ),
            ),
          ],
        ),
        body: Container(
          child: Stack(
            children: [
              Container(child: Text("Principais Noticias sobre Criptomoedas")),
              DesignerEspacamentos.verticalMedio,
              //ListView.builder(itemBuilder: ,),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(child: Container()),
      ),
    );
  }
}
