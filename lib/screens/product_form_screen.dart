import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_services_products.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;
  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _key = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _c;
  bool _saving = false;
  bool get _edit => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _c = {
      'title': TextEditingController(text: p?.title ?? ''),
      'category': TextEditingController(text: p?.category ?? ''),
      'brand': TextEditingController(text: p?.brand ?? ''),
      'price': TextEditingController(text: p == null ? '' : p.price.toString()),
      'stock': TextEditingController(text: p == null ? '' : p.stock.toString()),
      'thumbnail': TextEditingController(text: p?.thumbnail ?? ''),
      'description': TextEditingController(text: p?.description ?? ''),
    };
  }

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_key.currentState!.validate()) return;
    setState(() => _saving = true);
    final data = <String, dynamic>{
      'title': _c['title']!.text.trim(),
      'category': _c['category']!.text.trim(),
      'brand': _c['brand']!.text.trim(),
      'price': double.parse(_c['price']!.text.trim()),
      'stock': int.parse(_c['stock']!.text.trim()),
      'thumbnail': _c['thumbnail']!.text.trim(),
      'description': _c['description']!.text.trim(),
    };
    try {
      final api = ApiServiceProducts();
      if (_edit) {
        await api.updateProduct(widget.product!.id, data);
      } else {
        await api.addProduct(data);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
    }
  }

  Widget _f(String label, String k, {bool req = false, bool num = false, bool dec = false, int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: _c[k],
        maxLines: lines,
        keyboardType: num ? const TextInputType.numberWithOptions(decimal: true) : null,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: (v) {
          final s = (v ?? '').trim();
          if (req && s.isEmpty) return '$label wajib diisi';
          if (num && dec && double.tryParse(s) == null) return 'Angka tidak valid';
          if (num && !dec && int.tryParse(s) == null) return 'Bilangan bulat tidak valid';
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_edit ? 'Edit Produk' : 'Tambah Produk')),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _f('Judul', 'title', req: true),
            _f('Kategori', 'category', req: true),
            _f('Brand', 'brand'),
            _f('Harga', 'price', req: true, num: true, dec: true),
            _f('Stok', 'stock', req: true, num: true),
            _f('URL Thumbnail', 'thumbnail'),
            _f('Deskripsi', 'description', lines: 3),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(_edit ? 'Simpan Perubahan' : 'Tambah'),
            ),
          ],
        ),
      ),
    );
  }
}