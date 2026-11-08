import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/product_model.dart';

const String kBaseUrl = 'http://10.65.244.151:8000';
const String _ep = '/api/products.php';

class ApiServiceProducts {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: kBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
  ));

  static double _d(dynamic v) => double.tryParse('$v') ?? 0;
  static int _i(dynamic v) => (double.tryParse('$v') ?? 0).round();
  static dynamic _j(dynamic v, dynamic fb) {
    if (v is String) {
      try {
        v = jsonDecode(v);
      } catch (_) {
        return fb;
      }
    }
    if (fb is List) return v is List ? v : fb;
    return v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};
  }

  // Petakan baris backend -> bentuk yang dipahami Product.fromJson
  static Map<String, dynamic> _fix(dynamic row) =>
      jsonDecode(jsonEncode(_fix0(row))) as Map<String, dynamic>;

  static Map<String, dynamic> _fix0(dynamic row) {
    final r = Map<String, dynamic>.from(row as Map);
    final minQty = _i(r['minimum_order_quantity']);
    return {
      'id': _i(r['id']),
      'title': r['title'] ?? '',
      'description': r['description'] ?? '',
      'category': r['category'] ?? '',
      'price': _d(r['price']),
      'discountPercentage': _d(r['discount_percentage']),
      'rating': _d(r['rating']),
      'stock': _i(r['stock']),
      'brand': r['brand'] ?? '',
      'sku': r['sku'] ?? '',
      'weight': _i(r['weight']),
      'warrantyInformation': r['warranty_information'] ?? '',
      'shippingInformation': r['shipping_information'] ?? '',
      'availabilityStatus': r['availability_status'] ?? '',
      'returnPolicy': r['return_policy'] ?? '',
      'minimumOrderQuantity': minQty < 1 ? 1 : minQty,
      'thumbnail': r['thumbnail'] ?? '',
      'tags': _j(r['tags'], []),
      'images': _j(r['images'], []),
      'reviews': _j(r['reviews'], []),
      'dimensions': _j(r['dimensions'], {}),
      'meta': _j(r['meta'], {}),
    };
  }

  static const Map<String, dynamic> _defaults = {
    'description': '', 'brand': '', 'sku': '', 'weight': 0,
    'discount_percentage': 0, 'rating': 0, 'stock': 0,
    'warranty_information': '', 'shipping_information': '',
    'availability_status': 'In Stock', 'return_policy': '',
    'minimum_order_quantity': 1, 'thumbnail': '',
    'tags': [], 'images': [], 'reviews': [], 'dimensions': {}, 'meta': {},
  };

  Future<List<Product>> _all() async {
    final res = await _dio.get(_ep);
    return (res.data['data'] as List).map((e) => Product.fromJson(_fix(e))).toList();
  }

  ProductsResponse _page(List<Product> l, int limit, int skip) {
    final Iterable<Product> s = l.skip(skip);
    final p = (limit > 0 ? s.take(limit) : s).toList();
    return ProductsResponse(products: p, total: l.length, skip: skip, limit: limit);
  }

  Future<ProductsResponse> getAllProducts({int limit = 0, int skip = 0}) async {
    return _page(await _all(), limit, skip);
  }

  Future<Product> getProduct(int id) async {
    final res = await _dio.get(_ep, queryParameters: {'id': id});
    return Product.fromJson(_fix(res.data['data']));
  }

  Future<ProductsResponse> searchProducts(String query) async {
    final q = query.toLowerCase();
    final l = (await _all())
        .where((p) =>
            p.title.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.brand.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q))
        .toList();
    return _page(l, 0, 0);
  }

  Future<List<String>> getCategoryList() async {
    final c = (await _all()).map((p) => p.category).where((e) => e.isNotEmpty).toSet().toList();
    c.sort();
    return c;
  }

  Future<ProductsResponse> getProductsByCategory(String category) async {
    final l = (await _all()).where((p) => p.category == category).toList();
    return _page(l, 0, 0);
  }

  Future<Product> addProduct(Map<String, dynamic> data) async {
    final res = await _dio.post(_ep, data: {..._defaults, ...data});
    return Product.fromJson(_fix(res.data['data']));
  }

  Future<Product> updateProduct(int id, Map<String, dynamic> data) async {
    final res = await _dio.put(_ep, queryParameters: {'id': id}, data: data);
    return Product.fromJson(_fix(res.data['data']));
  }

  Future<void> deleteProduct(int id) async {
    await _dio.delete(_ep, queryParameters: {'id': id});
  }
}
