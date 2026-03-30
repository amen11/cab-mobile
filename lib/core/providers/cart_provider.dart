import 'dart:convert';
import 'package:cab_app/core/models/product.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/sanity_service.dart';
 
class CartItem {
  final ProductModel product;
  int quantity;
  String? customName;
  String? customNumber;
 
  CartItem({
    required this.product,
    this.quantity = 1,
    this.customName,
    this.customNumber,
  });
}
 
class CartProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  final List<CartItem> _items = [];
 
  CartProvider(this._prefs);
 
  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);
  double get total =>
      _items.fold(0, (sum, i) => sum + i.product.price * i.quantity);
 
  void addItem(ProductModel product,
      {String? customName, String? customNumber}) {
    final existing = _items.indexWhere((i) => i.product.id == product.id);
    if (existing >= 0) {
      _items[existing].quantity++;
    } else {
      _items.add(CartItem(
        product: product,
        customName: customName,
        customNumber: customNumber,
      ));
    }
    notifyListeners();
  }
 
  void removeItem(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
    notifyListeners();
  }
 
  void updateQuantity(String productId, int qty) {
    final idx = _items.indexWhere((i) => i.product.id == productId);
    if (idx >= 0) {
      if (qty <= 0) {
        _items.removeAt(idx);
      } else {
        _items[idx].quantity = qty;
      }
      notifyListeners();
    }
  }
 
  void clear() {
    _items.clear();
    notifyListeners();
  }
 
  Future<bool> submitOrder({
    required String name,
    required String phone,
    String? address,
    required String paymentMethod,
  }) async {
    try {
      final orderItems = _items.map((i) => {
        '_type': 'object',
        'product': {'_type': 'reference', '_ref': i.product.id},
        'quantity': i.quantity,
        if (i.customName != null) 'customName': i.customName,
        if (i.customNumber != null) 'customNumber': i.customNumber,
      }).toList();
 
      await SanityService.mutate([
        {
          'create': {
            '_type': 'order',
            'customerName': name,
            'phone': phone,
            if (address != null) 'address': address,
            'paymentMethod': paymentMethod,
            'items': orderItems,
            'totalAmount': total,
            'status': 'pending',
            'createdAt': DateTime.now().toIso8601String(),
          }
        }
      ]);
      clear();
      return true;
    } catch (e) {
      return false;
    }
  }
}