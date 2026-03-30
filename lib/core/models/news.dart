class NewsModel {
  final String id;
  final String title;
  final String? summary;
  final String? imageRef;
  final DateTime? publishedAt;
  final List<dynamic>? content; // Portable Text blocks
 
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
        title: json['title'],
        summary: json['summary'],
        imageRef: json['image']?['asset']?['_ref'],
        publishedAt: json['publishedAt'] != null
            ? DateTime.parse(json['publishedAt'])
            : null,
        content: json['content'],
      );
}