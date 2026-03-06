import 'package:cripto_din/domain/entities/noticias.dart';

class NoticiasModel extends Noticias {
  NoticiasModel({
    required super.uuid,
    required super.title,
    required super.description,
    required super.keywords,
    required super.snippet,
    required super.url,
    required super.imageUrl,
    required super.language,
    required super.publishedAt,
    required super.source,
    required super.categories,
    required super.relevanceScore,
    required super.locale,
  });

  //Criar modelo a partir da entidades
  factory NoticiasModel.fromEntity(Noticias noticias) {
    return NoticiasModel(
      uuid: noticias.uuid,
      title: noticias.title,
      description: noticias.description,
      keywords: noticias.keywords,
      snippet: noticias.snippet,
      url: noticias.url,
      imageUrl: noticias.imageUrl,
      language: noticias.language,
      publishedAt: noticias.publishedAt,
      source: noticias.source,
      categories: noticias.categories,
      relevanceScore: noticias.relevanceScore,
      locale: noticias.locale,
    );
  }

  /// Converte o modelo de volta para a entidade de domínio
  Noticias toEntity() {
    return Noticias(
      uuid: uuid,
      title: title,
      description: description,
      keywords: keywords,
      snippet: snippet,
      url: url,
      imageUrl: imageUrl,
      language: language,
      publishedAt: publishedAt,
      source: source,
      categories: categories,
      relevanceScore: relevanceScore,
      locale: locale,
    );
  }
}
