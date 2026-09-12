class NewsModel {
  final String id;
  final String title;
  final String? summary;
  final String? imageRef;
  final DateTime? publishedAt;
  final List<dynamic>? content;
 
  const NewsModel({
    required this.id,
    required this.title,
    this.summary,
    this.imageRef,
    this.publishedAt,
    this.content,
  });
 
  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        id: json['_id'],
        title: json['title'] ?? '',
        summary: json['summary'],
        // GROQ: image{asset->{_ref}}  → json['image']['asset']['_ref']  ✓
        imageRef: json['image']?['asset']?['_ref'],
        publishedAt: json['publishedAt'] != null
            ? DateTime.tryParse(json['publishedAt'])
            : null,
        content: json['content'],
      );
}