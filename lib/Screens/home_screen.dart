import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'product_details_screen.dart';
import 'product_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int index)? onNavigate;
  const HomeScreen({super.key, this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color kGreen = Color(0xFF2E7D32);
  static const Color kGreenDark = Color(0xFF1B5E20);
  static const Color kGreenLight = Color(0xFFE8F5E9);

  final PageController _bannerCtrl = PageController();
  int _bannerPage = 0;
  Timer? _bannerTimer;

  final List<_Banner> _banners = const [
    _Banner(
      title: 'Elegance\nRedefined',
      subtitle: 'Up to 30% off on Rings',
      image: 'assets/images/1.jpg',
    ),
    _Banner(
      title: 'Timeless\nCharm',
      subtitle: 'New Diamond Collection',
      image: 'assets/images/7.jpg',
    ),
    _Banner(
      title: 'Sparkle\nEvery Day',
      subtitle: 'Free shipping on orders \$150+',
      image: 'assets/images/9.jpg',
    ),
  ];

  final List<_Cat> _cats = const [
    _Cat('Rings', Icons.circle_outlined, 'assets/images/2.jpg'),
    _Cat('Earrings', Icons.spa_outlined, 'assets/images/3.jpg'),
    _Cat('Necklaces', Icons.auto_awesome, 'assets/images/5.jpg'),
    _Cat('Bracelets', Icons.watch_outlined, 'assets/images/11.jpg'),
  ];

  final List<Product> _featured = const [
    Product(
      id: 7,
      name: 'Solitaire Ring',
      price: 520.00,
      image: 'assets/images/9.jpg',
      category: 'Rings',
    ),
    Product(
      id: 8,
      name: 'Sapphire Pendant',
      price: 380.00,
      image: 'assets/images/10.jpg',
      category: 'Necklaces',
    ),
    Product(
      id: 5,
      name: 'Diamond Studs',
      price: 275.00,
      image: 'assets/images/7.jpg',
      category: 'Earrings',
    ),
    Product(
      id: 11,
      name: 'Tennis Bracelet',
      price: 340.00,
      image: 'assets/images/13.jpg',
      category: 'Bracelets',
    ),
  ];

  final List<Product> _newArrivals = const [
    Product(
      id: 0,
      name: 'Aquamarine Ring',
      price: 255.00,
      image: 'assets/images/1.jpg',
      category: 'Rings',
    ),
    Product(
      id: 2,
      name: 'Emerald Earrings',
      price: 180.00,
      image: 'assets/images/3.jpg',
      category: 'Earrings',
    ),
    Product(
      id: 3,
      name: 'Pearl Necklace',
      price: 420.00,
      image: 'assets/images/5.jpg',
      category: 'Necklaces',
    ),
    Product(
      id: 4,
      name: 'Rose Gold Bracelet',
      price: 140.00,
      image: 'assets/images/6.jpg',
      category: 'Bracelets',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_bannerCtrl.hasClients) return;
      final next = (_bannerPage + 1) % _banners.length;
      _bannerCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerCtrl.dispose();
    super.dispose();
  }

  void _goToProducts() => widget.onNavigate?.call(1);

  void _openProduct(Product p) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: p)));
  }

  @override
  Widget build(BuildContext context) {
    final name = FirebaseAuth.instance.currentUser?.displayName;
    final greeting = (name != null && name.trim().isNotEmpty)
        ? 'Hi, ${name.split(' ').first}'
        : 'Hello there';

    return Container(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _greetingHeader(greeting),
          const SizedBox(height: 14),
          _searchBar(),
          const SizedBox(height: 16),
          _heroBanner(),
          const SizedBox(height: 20),
          _sectionTitle('Shop by Category', onSeeAll: _goToProducts),
          const SizedBox(height: 10),
          _categoriesRow(),
          const SizedBox(height: 22),
          _sectionTitle('Featured', onSeeAll: _goToProducts),
          const SizedBox(height: 10),
          _featuredList(),
          const SizedBox(height: 20),
          _offerBanner(),
          const SizedBox(height: 20),
          _sectionTitle('New Arrivals', onSeeAll: _goToProducts),
          const SizedBox(height: 10),
          _newArrivalsGrid(),
          const SizedBox(height: 20),
          _trustBadges(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _greetingHeader(String greeting) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Find your perfect sparkle ✨',
                  style: TextStyle(
                    color: kGreenDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: kGreenLight,
              shape: BoxShape.circle,
              border: Border.all(color: kGreen.withValues(alpha: 0.3)),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: kGreenDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: GestureDetector(
        onTap: _goToProducts,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: kGreenLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.green.shade100),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: kGreenDark, size: 20),
              const SizedBox(width: 10),
              Text(
                'Search rings, necklaces, earrings…',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const Spacer(),
              const Icon(Icons.tune, color: kGreenDark, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          SizedBox(
            height: 170,
            child: PageView.builder(
              controller: _bannerCtrl,
              onPageChanged: (i) => setState(() => _bannerPage = i),
              itemCount: _banners.length,
              itemBuilder: (_, i) => _bannerCard(_banners[i]),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_banners.length, (i) {
              final active = i == _bannerPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active ? kGreen : Colors.green.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _bannerCard(_Banner b) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              b.image,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: kGreenLight),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    kGreenDark.withValues(alpha: 0.85),
                    kGreenDark.withValues(alpha: 0.15),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    b.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    b.subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _goToProducts,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: kGreenDark,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Shop Now',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kGreenDark,
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: const Row(
                children: [
                  Text(
                    'See all',
                    style: TextStyle(
                      color: kGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.arrow_forward_ios, color: kGreen, size: 12),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _categoriesRow() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _cats.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (_, i) => _categoryTile(_cats[i]),
      ),
    );
  }

  Widget _categoryTile(_Cat c) {
    return GestureDetector(
      onTap: _goToProducts,
      child: SizedBox(
        width: 78,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: kGreenLight,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green.shade100, width: 1.5),
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: ClipOval(
                    child: Image.asset(
                      c.image,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, e, s) =>
                          Icon(c.icon, color: kGreenDark, size: 28),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              c.name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: kGreenDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featuredList() {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _featured.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) => _horizontalProductCard(_featured[i]),
      ),
    );
  }

  Widget _horizontalProductCard(Product p) {
    return GestureDetector(
      onTap: () => _openProduct(p),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.green.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(13),
              ),
              child: Container(
                height: 130,
                color: kGreenLight,
                child: Image.asset(
                  p.image,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const Center(
                    child: Icon(Icons.diamond, color: kGreen, size: 32),
                  ),
                ),
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
                  const SizedBox(height: 2),
                  Text(
                    p.category,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${p.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: kGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFF5B400),
                        size: 14,
                      ),
                      const Text(
                        ' 4.8',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: kGreenDark,
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

  Widget _offerBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kGreen, kGreenDark],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'LIMITED TIME',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '20% Off Today',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Use code SPARKLE20 at checkout',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _goToProducts,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: kGreenDark,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Grab Deal',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.local_offer_rounded,
              color: Colors.white,
              size: 72,
            ),
          ],
        ),
      ),
    );
  }

  Widget _newArrivalsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _newArrivals.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (_, i) => _horizontalProductCard(_newArrivals[i]),
      ),
    );
  }

  Widget _trustBadges() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: kGreenLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            Expanded(
              child: _Badge(
                icon: Icons.local_shipping_outlined,
                label: 'Free\nShipping',
              ),
            ),
            _BadgeDivider(),
            Expanded(
              child: _Badge(
                icon: Icons.verified_outlined,
                label: '100%\nAuthentic',
              ),
            ),
            _BadgeDivider(),
            Expanded(
              child: _Badge(
                icon: Icons.shield_outlined,
                label: '1 Year\nWarranty',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Badge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF1B5E20), size: 24),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF1B5E20),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

class _BadgeDivider extends StatelessWidget {
  const _BadgeDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: Colors.green.shade200);
  }
}

class _Banner {
  final String title;
  final String subtitle;
  final String image;
  const _Banner({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}

class _Cat {
  final String name;
  final IconData icon;
  final String image;
  const _Cat(this.name, this.icon, this.image);
}
