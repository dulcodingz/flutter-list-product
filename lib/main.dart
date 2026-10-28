
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'models/product_model.dart';
import 'providers/product_provider.dart';
import 'services/api_services_products.dart';

const Color pastelBg = Color(0xFFF3F4F6);
const Color pastelPink = Color(0xFFFFFFFF);
const Color pastelBlue = Color(0xFFF7F7F7);
const Color pastelGreen = Color(0xFFE5E7EB);
const Color pastelText = Color(0xFF45404A);

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ProductListPage(),
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ProductDetailPage(id: id);
      },
    ),
  ],
);

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductProvider()..fetchProducts(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Pastel Products',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pastelBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: pastelPink,
          surface: pastelBg,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: pastelBg,
          foregroundColor: pastelText,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      routerConfig: _router,
    );
  }
}

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController _searchController =
      TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                'Temukan produk favoritmu ✨',
                style: TextStyle(
                  fontSize: 15,
                  color: pastelText,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  context.read<ProductProvider>()
                      .searchProducts(value.trim());
                },
                decoration: InputDecoration(
                  hintText: 'Cari produk...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            context.read<ProductProvider>()
                                .searchProducts('');
                            setState(() {});
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                provider.loading
                    ? 'Memuat produk...'
                    : '${provider.products.length} produk ditampilkan',
                style: const TextStyle(
                  color: pastelText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _buildProductContent(provider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductContent(ProductProvider provider) {
    if (provider.loading && provider.products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.products.isEmpty) {
      return const Center(
        child: Text('Produk tidak ditemukan 😕'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ProductProvider>().fetchProducts(),
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.64,
        ),
        itemCount: provider.products.length,
        itemBuilder: (context, index) {
          final product = provider.products[index];
          
          final cardColor = index ~/ 2 % 2 == 0
            ? Colors.white
            : const Color(0xFFE8EDF2);
          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => context.push('/detail/${product.id}'),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: Image.network(
                        product.thumbnail,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported,
                                size: 48),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: pastelText,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF735A85),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Stok: ${product.stock}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  final int id;

  const ProductDetailPage({super.key, required this.id});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<Product> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = ApiServiceProducts().getProduct(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text('Gagal memuat detail produk.'),
            );
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 260,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: pastelBlue,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Image.network(
                    product.thumbnail,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image_not_supported, size: 60),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: pastelText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF735A85),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _infoChip('ID: ${product.id}', pastelPink),
                    _infoChip('Stok: ${product.stock}', pastelGreen),
                    _infoChip(product.category, pastelBlue),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Deskripsi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: pastelText,
                  ),
                ),
                if (product.brand != null &&
                    product.brand!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('Merek: ${product.brand}'),
                ],
                const SizedBox(height: 16),
                Text('Rating: ⭐ ${product.rating}'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoChip(String text, Color color) {
    return Chip(
      label: Text(text),
      backgroundColor: color,
      side: BorderSide.none,
    );
  }
}
