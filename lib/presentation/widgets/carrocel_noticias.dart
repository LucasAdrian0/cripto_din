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
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: StreamBuilder<List<Noticias>>(
        stream: widget.repository.getNoticias(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Sem notícias"));
          }

          final noticias = snapshot.data!;

          return PageView.builder(
            itemCount: noticias.length,
            controller: PageController(viewportFraction: 0.9),
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
    return ClipRRect(
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
                // ignore: deprecated_member_use
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
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
    );
  }
}
