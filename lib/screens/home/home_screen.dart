import 'package:flutter/material.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/product_card.dart';
import '../../models/product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool isLoading = false;
  String? error;

  // Temporary mock data (later from Supabase)
  final List<Product> products = [
    Product(id: 1, name: 'Used iPhone 12', category: 'Phones', price: 320),
    Product(id: 2, name: 'Gaming Laptop', category: 'Laptops', price: 750),
  ];

  List<Product> get filteredProducts {
    final query = _searchController.text.toLowerCase();
    return products.where((p) {
      return p.name.toLowerCase().contains(query) ||
          p.category.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      /// HEADER
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withValues(alpha: .9),
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 12),
            Image.asset(
              'assets/images/thriftly_logo.png',
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 8),
            const Text(
              'Thriftly',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      /// BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// SEARCH BAR
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'What are you looking for?',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// PROMO SECTION (placeholder)
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  '🔥 Promo Carousel',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 32),

            /// CATEGORIES
            _sectionHeader('Categories'),
            const SizedBox(height: 12),

            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  CategoryChip(label: 'Phones'),
                  CategoryChip(label: 'Laptops'),
                  CategoryChip(label: 'Cars'),
                  CategoryChip(label: 'Furniture'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            /// FEATURED PRODUCTS
            _sectionHeader('Featured'),

            const SizedBox(height: 16),

            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (error != null)
              Center(
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              )
            else if (filteredProducts.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text('No products found'),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ProductCard(product: product);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton(onPressed: () {}, child: const Text('See All')),
      ],
    );
  }
}
