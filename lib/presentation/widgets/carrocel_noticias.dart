import 'package:cripto_din/presentation/pages/noticias_page/noticias_webView.dart';
import 'package:flutter/material.dart';
import 'package:cripto_din/domain/entities/noticias.dart';
import 'package:cripto_din/domain/repositories/noticias_repository.dart';

class CarrocelDeNoticias extends StatefulWidget {
  final NoticiasRepository repository;

  const CarrocelDeNoticias({super.key, required this.repository});

  @override
  State<CarrocelDeNoticias> createState() => _CarrocelDeNoticiasState();
}

class _CarrocelDeNoticiasState extends State<CarrocelDeNoticias> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: StreamBuilder<List<Noticias>>(
        stream: widget.repository.buscarNoticias(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Sem notícias"));
          }

          final noticias = snapshot.data!;

          return PageView.builder(
            controller: _controller,
            itemCount: noticias.length,
            //controller: PageController(viewportFraction: 0.9),
            itemBuilder: (context, index) {
              final noticia = noticias[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _CardNoticia(noticia: noticia),
              );
            },
          );
        },
      ),
    );
  }
}

class _CardNoticia extends StatelessWidget {
  final Noticias noticia;

  const _CardNoticia({required this.noticia});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NoticiaWebView(url: noticia.url)),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(noticia.imageUrl, fit: BoxFit.cover),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Text(
                noticia.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
