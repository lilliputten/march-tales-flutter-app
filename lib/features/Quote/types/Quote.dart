class Quote {
  final String id;
  final String content;
  final String author;
  final List<String> tags; // "tags": ["Famous Quotes"]
  final String authorSlug; // "authorSlug": "e-e-cummings"

  const Quote({
    required this.id,
    required this.content,
    required this.author,
    required this.tags,
    required this.authorSlug,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    try {
      return Quote(
        id: json['id'].toString(),
        content: json['content'].toString(),
        author: json['author'].toString(),
        tags: List<String>.from(json['tags'] as List),
        authorSlug: json['authorSlug'].toString(),
      );
    } catch (e) {
      final String msg = "Something really unknown: $e";
      print(msg);
      throw FormatException(msg);
    }
  }
}
