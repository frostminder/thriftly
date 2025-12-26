import 'package:flutter/material.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/product_card.dart';
import '../../models/product_model.dart';
import '../../widgets/promo_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";

  bool isLoading = false;
  String? error;

  bool _isSearchOpen = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _toggleSearch() {
    setState(() {
      _isSearchOpen = !_isSearchOpen;
      if (_isSearchOpen) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _focusNode.requestFocus();
        });
      } else {
        _searchController.clear();
        _focusNode.unfocus();
        searchQuery = "";
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

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
              width: 46,
              height: 46,
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
          // Animated search container
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isSearchOpen ? 250 : 50,
            height: 40,
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: _toggleSearch,
                ),
                if (_isSearchOpen)
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        hintText: "Search",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 7.5),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value; // your filter logic
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),

          // Cart Icon
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
            const SizedBox(height: 24),

            // Promo Slider
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const PromoCarousel(),
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
