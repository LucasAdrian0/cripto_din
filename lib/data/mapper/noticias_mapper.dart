import 'package:cripto_din/data/model/noticias_model.dart';

class NoticiasMapper {
  /// Converte JSON da API para NoticiasModel
  static NoticiasModel fromApiJson(Map<String, dynamic> json) {
    return NoticiasModel(
      uuid: json['uuid'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      keywords: json['keywords'] ?? '',
      snippet: json['snippet'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['image_url'] ?? '',
      language: json['language'] ?? '',
      publishedAt: json['published_at'] ?? '',
      source: json['source'] ?? '',
      categories: (json['categories'] as List?)?.cast<String>() ?? [],
      relevanceScore: json['relevance_score'] ?? '',
      locale: json['locale'] ?? '',
    );
  }

  /// Converte Map (Firestore) para NoticiasModel
  static NoticiasModel fromMap(Map<String, dynamic> map) {
    return NoticiasModel(
      uuid: map['uuid'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      keywords: map['keywords'] ?? '',
      snippet: map['snippet'] ?? '',
      url: map['url'] ?? '',
      imageUrl: map['image_url'] ?? '',
      language: map['language'] ?? '',
      publishedAt: map['published_at'] ?? '',
      source: map['source'] ?? '',
      categories: (map['categories'] as List?)?.cast<String>() ?? [],
      relevanceScore: map['relevance_score'] ?? '',
      locale: map['locale'] ?? '',
    );
  }

  /// Converte NoticiasModel para Map (Firestore)
  static Map<String, dynamic> toMap(NoticiasModel noticias) {
    return {
      'uuid': noticias.uuid,
      'title': noticias.title,
      'description': noticias.description,
      'keywords': noticias.keywords,
      'snippet': noticias.snippet,
      'url': noticias.url,
      'image_url': noticias.imageUrl,
      'language': noticias.language,
      'published_at': noticias.publishedAt,
      'source': noticias.source,
      'categories': noticias.categories,
      'relevance_score': noticias.relevanceScore,
      'locale': noticias.locale,
    };
  }
}
