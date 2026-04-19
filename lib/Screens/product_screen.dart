import 'dart:async';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  static const Color kGreen = Color(0xFF2E7D32);
  static const Color kGreenDark = Color(0xFF1B5E20);
  static const Color kGreenLight = Color(0xFFE8F5E9);

  String _selectedCategory = 'All';
  final Set<int> _favorites = {};

  final TextEditingController _searchCtrl = TextEditingController();
  String _search = '';

  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _sliderTimer;

  final List<String> _sliderImages = const [
    'assets/images/1.jpg',
    'assets/images/3.jpg',
    'assets/images/5.jpg',
    'assets/images/7.jpg',
    'assets/images/9.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _startSliderTimer();
    _searchCtrl.addListener(() {
      setState(() => _search = _searchCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _pageController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _startSliderTimer() {
    _sliderTimer?.cancel();
    _sliderTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final next = (_currentPage + 1) % _sliderImages.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  void _goToSlide(int index) {
    final target = index % _sliderImages.length;
    _pageController.animateToPage(
      target < 0 ? _sliderImages.length - 1 : target,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
    _startSliderTimer();
  }

  final List<_Product> _products = const [
    _Product(
      id: 0,
      name: 'Aquamarine Ring',
      price: 255.00,
      image: 'assets/images/1.jpg',
      category: 'Rings',
    ),
    _Product(
      id: 1,
      name: 'Gold Diamond',
      price: 300.00,
      image: 'assets/images/2.jpg',
      category: 'Rings',
    ),
    _Product(
      id: 2,
      name: 'Emerald Earrings',
      price: 180.00,
      image: 'assets/images/3.jpg',
      category: 'Earrings',
    ),
    _Product(
      id: 3,
      name: 'Pearl Necklace',
      price: 420.00,
      image: 'assets/images/5.jpg',
      category: 'Necklaces',
    ),
    _Product(
      id: 4,
      name: 'Rose Gold Bracelet',
      price: 140.00,
      image: 'assets/images/6.jpg',
      category: 'Bracelets',
    ),
    _Product(
      id: 5,
      name: 'Diamond Studs',
      price: 275.00,
      image: 'assets/images/7.jpg',
      category: 'Earrings',
    ),
    _Product(
      id: 6,
      name: 'Silver Chain',
      price: 95.00,
      image: 'assets/images/8.jpg',
      category: 'Necklaces',
    ),
    _Product(
      id: 7,
      name: 'Solitaire Ring',
      price: 520.00,
      image: 'assets/images/9.jpg',
      category: 'Rings',
    ),
    _Product(
      id: 8,
      name: 'Sapphire Pendant',
      price: 380.00,
      image: 'assets/images/10.jpg',
      category: 'Necklaces',
    ),
    _Product(
      id: 9,
      name: 'Classic Bangle',
      price: 210.00,
      image: 'assets/images/11.jpg',
      category: 'Bracelets',
    ),
    _Product(
      id: 10,
      name: 'Crystal Drops',
      price: 165.00,
      image: 'assets/images/12.jpg',
      category: 'Earrings',
    ),
    _Product(
      id: 11,
      name: 'Tennis Bracelet',
      price: 340.00,
      image: 'assets/images/13.jpg',
      category: 'Bracelets',
    ),
  ];

  List<_Product> get _filtered {
    return _products.where((p) {
      final matchCat =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchSearch =
          _search.isEmpty || p.name.toLowerCase().contains(_search);
      return matchCat && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: _searchBar(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
              child: _heroSlider(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: _promoBanner(),
            ),
          ),
          SliverToBoxAdapter(child: _sectionHeader(items.length)),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverToBoxAdapter(child: _categoryBar()),
          const SliverToBoxAdapter(child: SizedBox(height: 14)),
          if (items.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.search_off_rounded,
                        size: 48,
                        color: kGreen,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _search.isNotEmpty
                            ? 'No results for "${_searchCtrl.text}"'
                            : 'No products in this category',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.70,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _productCard(items[i]),
                  childCount: items.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return TextField(
      controller: _searchCtrl,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search jewelry...',
        hintStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: const Icon(Icons.search, color: kGreen),
        suffixIcon: _searchCtrl.text.isEmpty
            ? null
            : IconButton(
                icon: Icon(Icons.close, color: Colors.grey.shade600),
                onPressed: () {
                  _searchCtrl.clear();
                  FocusScope.of(context).unfocus();
                },
              ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.green.shade100, width: 1.3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kGreen, width: 1.6),
        ),
      ),
    );
  }

  Widget _heroSlider() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 180,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _sliderImages.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, i) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      _sliderImages[i],
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        color: kGreenLight,
                        child: const Center(
                          child: Icon(Icons.diamond, color: kGreen, size: 48),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.55),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 18,
                      bottom: 18,
                      right: 18,
                      child: Text(
                        'Discover Timeless Elegance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              left: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: _sliderArrow(
                  Icons.chevron_left,
                  () => _goToSlide(_currentPage - 1),
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: _sliderArrow(
                  Icons.chevron_right,
                  () => _goToSlide(_currentPage + 1),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_sliderImages.length, (i) {
                  final active = i == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sliderArrow(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white.withValues(alpha: 0.85),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, color: kGreenDark, size: 22),
        ),
      ),
    );
  }

  Widget _promoBanner() {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: kGreenDark,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 8, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Get 20% Off\nfor all Items',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.15,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Promo until 20 May 2026',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                'assets/images/7.jpg',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.white10,
                  child: const Icon(
                    Icons.diamond,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Our Collection',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kGreenDark,
            ),
          ),
          Text(
            '$count items',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _categoryBar() {
    const categories = ['All', 'Necklaces', 'Earrings', 'Rings', 'Bracelets'];
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (a, b) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final c = categories[i];
          final selected = c == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = c),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? kGreen : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: selected ? kGreen : Colors.green.shade100,
                  width: 1.2,
                ),
              ),
              child: Text(
                c,
                style: TextStyle(
                  color: selected ? Colors.white : kGreenDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _productCard(_Product p) {
    final isFav = _favorites.contains(p.id);
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${p.name} — \$${p.price.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: kGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(12),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: Container(
                        color: kGreenLight,
                        child: Image.asset(
                          p.image,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Center(
                            child: Icon(Icons.diamond, color: kGreen, size: 40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isFav) {
                            _favorites.remove(p.id);
                          } else {
                            _favorites.add(p.id);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: kGreen,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kGreenDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${p.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: kGreen,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: kGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Product {
  final int id;
  final String name;
  final double price;
  final String image;
  final String category;

  const _Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
  });
}
