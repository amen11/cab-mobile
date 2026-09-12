class ProductModel {
  final String id;
  final String title;
  final List<String> imageRefs; // list of Sanity image asset _ref strings
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
 
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // GROQ:  images[]{asset->{_ref}}
    // This dereferences the asset, so each image item =
    // { 'asset': { '_ref': '...', '_id': '...' } }
    // BUT after ->{_ref} the asset object only has _ref field projected
    // so: image item = { 'asset': { '_ref': 'image-abc-800x600-jpg' } }
    List<String> refs = [];
    final images = json['images'];
    if (images is List) {
      for (final img in images) {
        if (img is Map) {
          final assetRef = img['asset']?['_ref'] as String?;
          if (assetRef != null && assetRef.isNotEmpty) {
            refs.add(assetRef);
          }
        }
      }
    }
 
    return ProductModel(
      id: json['_id'],
      title: json['title'] ?? '',
      imageRefs: refs,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: json['description'],
      category: json['category'] ?? 'accessories',
      customizable: json['customizable'] ?? false,
      inStock: json['inStock'] ?? true,
    );
  }
}
 