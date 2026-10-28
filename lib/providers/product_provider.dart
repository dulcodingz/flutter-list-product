import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_services_products.dart';

class ProductProvider extends ChangeNotifier {
  final ApiServiceProducts _api = ApiServiceProducts();
  List<Product> _products = [];
  List<String> _categoryList = [];
  bool _loading = false;
  String? _error;
  int _total = 0;
  int _skip = 0;
  String _selectedCategory = '';

  List<Product> get products => _products;
  List<String> get categoryList => _categoryList;
  bool get loading => _loading;
  int get total => _total;

  Future<void> fetchProducts({int limit = 0, int skip = 0}) async {
    _loading = true;
    notifyListeners();
    final res = await _api.getAllProducts(limit: limit, skip: skip);
    _products = res.products;
    _total = res.total;
    _loading = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    _categoryList = await _api.getCategoryList();
    notifyListeners();
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) return fetchProducts();
    _loading = true;
    notifyListeners();
    final res = await _api.searchProducts(query);
    _products = res.products;
    _loading = false;
    notifyListeners();
  }

  Future<void> filterByCategory(String category) async {
    _selectedCategory = category;
    _loading = true;
    notifyListeners();
    final res = await _api.getProductsByCategory(category);
    _products = res.products;
    _loading = false;
    notifyListeners();
  }

  Future<bool> updateProduct(int id, Product updated) async {
    _loading = true;
    notifyListeners();
    final result = await _api.updateProduct(id, updated.toJson());
    int idx = _products.indexWhere((p) => p.id == id);
    if (idx != -1) _products[idx] = result;
    _loading = false;
    notifyListeners();
    return true;
  }
}