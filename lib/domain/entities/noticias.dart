class Noticias {
  final String uuid;
  final String title;
  final String description;
  final String keywords;
  final String snippet;
  final String url;
  final String imageUrl;
  final String language;
  final String publishedAt;
  final String source;
  List<String> categories;
  final String relevanceScore;
  final String locale;

  Noticias({
    required this.uuid,
    required this.title,
    required this.description,
    required this.keywords,
    required this.snippet,
    required this.url,
    required this.imageUrl,
    required this.language,
    required this.publishedAt,
    required this.source,
    required this.categories,
    required this.relevanceScore,
    required this.locale,
  });
}
