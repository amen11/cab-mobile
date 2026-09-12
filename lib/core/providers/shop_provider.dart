import 'package:cab_app/core/models/product.dart';
import 'package:cab_app/core/services/sanity_service.dart';
import 'package:flutter/material.dart';

class ShopProvider extends ChangeNotifier {
  List<ProductModel> _products         = [];
  String             _selectedCategory = 'all';
  bool               _loading          = false;
  String?            _error;
 
  List<ProductModel> get products         => _products;
  String             get selectedCategory => _selectedCategory;
  bool               get loading          => _loading;
  String?            get error            => _error;
 
  List<ProductModel> get filtered => _selectedCategory == 'all'
      ? _products
      : _products.where((p) => p.category == _selectedCategory).toList();
 
  void setCategory(String cat) {
    _selectedCategory = cat;
    notifyListeners();
  }
 
  Future<void> fetchProducts() async {
    _loading = true;
    _error   = null;
    notifyListeners();
    try {
      // images[]{ asset->{ _ref } }  → each item: { asset: { _ref: 'image-...' } }
      final results = await SanityService.query(
        r'''*[_type == "product" && inStock == true] | order(_createdAt desc) {
          _id, title, price, description, category, customizable, inStock,
          images[]{ asset }
        }''',
      );
      _products = results
          .map((r) => ProductModel.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _error = e.toString();
      debugPrint('ShopProvider error: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}