import 'package:cab_app/core/models/product.dart';
import 'package:flutter/foundation.dart';
import '../services/sanity_service.dart';
 
class ShopProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  String _selectedCategory = 'all';
  bool _loading = false;
  String? _error;
 
  List<ProductModel> get products => _products;
  String get selectedCategory => _selectedCategory;
  bool get loading => _loading;
  String? get error => _error;
 
  List<ProductModel> get filtered => _selectedCategory == 'all'
      ? _products
      : _products.where((p) => p.category == _selectedCategory).toList();
 
  void setCategory(String cat) {
    _selectedCategory = cat;
    notifyListeners();
  }
 
  Future<void> fetchProducts() async {
    _loading = true;
    notifyListeners();
    try {
      final results = await SanityService.query(
        '''*[_type == "product" && inStock == true] | order(_createdAt desc) {
          _id, title, price, description, category, customizable, inStock,
          images[]{asset->{_ref}}
        }''',
      );
      _products = results.map((r) => ProductModel.fromJson(r)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}