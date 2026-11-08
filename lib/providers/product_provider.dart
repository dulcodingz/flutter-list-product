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
  String _selectedCategory = '';

  List<Product> get products => _products;
  List<String> get categoryList => _categoryList;
  bool get loading => _loading;
  String? get error => _error;
  int get total => _total;
  String get selectedCategory => _selectedCategory;

  Future<void> _run(Future<void> Function() job) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await job();
    } catch (e) {
      _error = 'Gagal memuat data: $e';
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> fetchProducts({int limit = 0, int skip = 0}) => _run(() async {
        final res = await _api.getAllProducts(limit: limit, skip: skip);
        _products = res.products;
        _total = res.total;
      });

  Future<void> fetchCategories() async {
    try {
      _categoryList = await _api.getCategoryList();
    } catch (e) {
      _error = 'Gagal memuat kategori: $e';
    }
    notifyListeners();
  }

  Future<void> searchProducts(String query) {
    if (query.isEmpty) return fetchProducts();
    return _run(() async {
      final res = await _api.searchProducts(query);
      _products = res.products;
    });
  }

  Future<void> filterByCategory(String category) {
    _selectedCategory = category;
    return _run(() async {
      final res = await _api.getProductsByCategory(category);
      _products = res.products;
    });
  }

  Future<bool> addProduct(Map<String, dynamic> data) async {
    try {
      await _api.addProduct(data);
      await fetchProducts();
      return true;
    } catch (e) {
      _error = 'Gagal menambah: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(int id, Product updated) async {
    try {
      final result = await _api.updateProduct(id, updated.toJson());
      final idx = _products.indexWhere((p) => p.id == id);
      if (idx != -1) _products[idx] = result;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Gagal mengubah: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      await _api.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      _total = _total > 0 ? _total - 1 : 0;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Gagal menghapus: $e';
      notifyListeners();
      return false;
    }
  }
}