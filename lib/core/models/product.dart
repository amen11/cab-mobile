class ProductModel {
  final String id;
  final String title;
  final List<String> imageRefs;
  final double price;
  final String? description;
  final String category;
  final bool customizable;
  final bool inStock;
 
  const ProductModel({
    required this.id,
    required this.title,
    required this.imageRefs,
    required this.price,
    this.description,
    required this.category,
    this.customizable = false,
    this.inStock = true,
  });
 
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['_id'],
        title: json['title'],
        imageRefs: (json['images'] as List<dynamic>?)
                ?.map((i) => i['asset']['_ref'] as String)
                .toList() ??
            [],
        price: (json['price'] as num).toDouble(),
        description: json['description'],
        category: json['category'] ?? 'accessories',
        customizable: json['customizable'] ?? false,
        inStock: json['inStock'] ?? true,
      );
}
 

