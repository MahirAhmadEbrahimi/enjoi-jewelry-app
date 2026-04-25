import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/cart_service.dart';
import '../services/favorites_service.dart';
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

  final List<_Occasion> _occasions = const [
    _Occasion('Wedding', Icons.favorite_rounded, Color(0xFFE91E63)),
    _Occasion('Anniversary', Icons.celebration, Color(0xFFFF7043)),
    _Occasion('Birthday', Icons.cake_rounded, Color(0xFFAB47BC)),
    _Occasion('Daily Wear', Icons.wb_sunny_rounded, Color(0xFFFFA000)),
    _Occasion('Gifting', Icons.card_giftcard_rounded, Color(0xFF42A5F5)),
    _Occasion('Party', Icons.nightlife_rounded, Color(0xFF5C6BC0)),
  ];

  final List<_Collection> _collections = const [
    _Collection(
      'Bridal',
      'Timeless pieces for your big day',
      'assets/images/9.jpg',
    ),
    _Collection(
      'Minimalist',
      'Subtle elegance, everyday shine',
      'assets/images/3.jpg',
    ),
    _Collection(
      'Statement',
      'Bold designs that stand out',
      'assets/images/13.jpg',
    ),
  ];

  final List<_Tip> _tips = const [
    _Tip(
      Icons.water_drop_outlined,
      'Cleaning',
      'Use mild soap and warm water. Dry gently with a soft cloth.',
    ),
    _Tip(
      Icons.inventory_2_outlined,
      'Storing',
      'Keep pieces separately in soft pouches to avoid scratches.',
    ),
    _Tip(
      Icons.block_outlined,
      'Avoid',
      'Remove jewelry before swimming, bathing, or using chemicals.',
    ),
  ];

  final List<_Testimonial> _testimonials = const [
    _Testimonial(
      'Sarah K.',
      'Absolutely stunning quality! The ring exceeded my expectations.',
      5,
    ),
    _Testimonial(
      'Priya M.',
      'Fast delivery and beautiful packaging. Will buy again!',
      5,
    ),
    _Testimonial(
      'Emma R.',
      'My necklace gets compliments every day. Worth every penny.',
      4,
    ),
  ];

  final List<String> _priceRanges = const [
    'Under \$100',
    '\$100 - \$300',
    '\$300 - \$500',
    '\$500+',
  ];

  Timer? _countdownTimer;
  Duration _dealRemaining = const Duration(hours: 12, minutes: 34, seconds: 56);

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
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_dealRemaining.inSeconds <= 0) {
          _dealRemaining = const Duration(hours: 23, minutes: 59, seconds: 59);
        } else {
          _dealRemaining -= const Duration(seconds: 1);
        }
      });
    });
    CartService.instance.addListener(_onServiceChanged);
    FavoritesService.instance.addListener(_onServiceChanged);
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _countdownTimer?.cancel();
    _bannerCtrl.dispose();
    CartService.instance.removeListener(_onServiceChanged);
    FavoritesService.instance.removeListener(_onServiceChanged);
    super.dispose();
  }

  void _onServiceChanged() {
    if (mounted) setState(() {});
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
          const SizedBox(height: 14),
          _statsStrip(),
          const SizedBox(height: 18),
          _heroBanner(),
          const SizedBox(height: 22),
          _sectionTitle('Shop by Occasion'),
          const SizedBox(height: 10),
          _occasionsRow(),
          const SizedBox(height: 22),
          _sectionTitle('Shop by Category', onSeeAll: _goToProducts),
          const SizedBox(height: 10),
          _categoriesRow(),
          const SizedBox(height: 22),
          _sectionTitle('⚡ Deal of the Day'),
          const SizedBox(height: 10),
          _dealOfTheDay(),
          const SizedBox(height: 22),
          _sectionTitle('Curated Collections'),
          const SizedBox(height: 10),
          _collectionsRow(),
          const SizedBox(height: 22),
          _sectionTitle('🔥 Trending Now', onSeeAll: _goToProducts),
          const SizedBox(height: 10),
          _trendingList(),
          const SizedBox(height: 22),
          _sectionTitle('Shop by Price'),
          const SizedBox(height: 10),
          _priceRangeChips(),
          const SizedBox(height: 22),
          _offerBanner(),
          const SizedBox(height: 22),
          _sectionTitle('Jewelry Care Tips'),
          const SizedBox(height: 10),
          _careTipsRow(),
          const SizedBox(height: 22),
          _sectionTitle('What Customers Say'),
          const SizedBox(height: 10),
          _testimonialsRow(),
          const SizedBox(height: 22),
          _brandStats(),
          const SizedBox(height: 22),
          _trustBadges(),
          const SizedBox(height: 18),
          _newsletter(),
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

  Widget _trendingList() {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _featured.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) => Stack(
          children: [
            _horizontalProductCard(_featured[i]),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: kGreenDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '#${i + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
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

  Widget _statsStrip() {
    final favs = FavoritesService.instance.count;
    final cart = CartService.instance.count;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              Icons.favorite_rounded,
              '$favs',
              'Favorites',
              () => widget.onNavigate?.call(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _statCard(
              Icons.shopping_bag_rounded,
              '$cart',
              'In Cart',
              () {},
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _statCard(
              Icons.local_offer_rounded,
              '20%',
              'Today Off',
              _goToProducts,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    IconData icon,
    String value,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: kGreenLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.green.shade100),
        ),
        child: Column(
          children: [
            Icon(icon, color: kGreenDark, size: 22),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kGreenDark,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: TextStyle(fontSize: 10.5, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _occasionsRow() {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _occasions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final o = _occasions[i];
          return GestureDetector(
            onTap: _goToProducts,
            child: SizedBox(
              width: 76,
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: o.color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(o.icon, color: o.color, size: 26),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    o.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: kGreenDark,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  Widget _dealOfTheDay() {
    final p = _featured.first;
    final h = _twoDigits(_dealRemaining.inHours);
    final m = _twoDigits(_dealRemaining.inMinutes.remainder(60));
    final s = _twoDigits(_dealRemaining.inSeconds.remainder(60));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: GestureDetector(
        onTap: () => _openProduct(p),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: SizedBox(
                  width: 120,
                  height: 130,
                  child: Image.asset(p.image, fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _dealInfo(p, h, m, s),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dealInfo(Product p, String h, String m, String s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEBEE),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            '-25% TODAY',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFFC62828),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          p.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: kGreenDark,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(
              '\$${(p.price * 0.75).toStringAsFixed(2)}',
              style: const TextStyle(
                color: kGreen,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '\$${p.price.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.timer_outlined, color: kGreenDark, size: 14),
            const SizedBox(width: 4),
            _timeBox(h),
            const Text(' : ', style: TextStyle(color: kGreenDark)),
            _timeBox(m),
            const Text(' : ', style: TextStyle(color: kGreenDark)),
            _timeBox(s),
          ],
        ),
      ],
    );
  }

  Widget _timeBox(String v) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: kGreenDark,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        v,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _collectionsRow() {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _collections.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final c = _collections[i];
          return GestureDetector(
            onTap: _goToProducts,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: 240,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      c.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(color: kGreenLight),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.65),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            c.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            c.subtitle,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _priceRangeChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _priceRanges.map((r) {
          return GestureDetector(
            onTap: _goToProducts,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: kGreen, width: 1.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sell_outlined, size: 14, color: kGreenDark),
                  const SizedBox(width: 6),
                  Text(
                    r,
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
        }).toList(),
      ),
    );
  }

  Widget _careTipsRow() {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _tips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final t = _tips[i];
          return Container(
            width: 220,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [kGreenLight, Colors.white],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: kGreenDark,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(t.icon, color: Colors.white, size: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  t.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kGreenDark,
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    t.body,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey.shade700,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _testimonialsRow() {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _testimonials.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final t = _testimonials[i];
          return Container(
            width: 260,
            padding: const EdgeInsets.all(14),
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
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: kGreenLight,
                      child: Text(
                        t.name.substring(0, 1),
                        style: const TextStyle(
                          color: kGreenDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: kGreenDark,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (j) => Icon(
                              j < t.stars
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: const Color(0xFFF5B400),
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(
                    '"${t.body}"',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      height: 1.4,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _brandStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [kGreenDark, kGreen],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: const [
            Expanded(
              child: _BrandStat(value: '10K+', label: 'Happy\nCustomers'),
            ),
            _BrandStatDivider(),
            Expanded(
              child: _BrandStat(value: '4.9★', label: 'Average\nRating'),
            ),
            _BrandStatDivider(),
            Expanded(
              child: _BrandStat(value: '500+', label: 'Unique\nDesigns'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _newsletter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kGreenLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.mail_outline_rounded, color: kGreenDark, size: 20),
                SizedBox(width: 8),
                Text(
                  'Join our newsletter',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: kGreenDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Get 10% off your first order + early access to new drops.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.alternate_email_rounded,
                          size: 16,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'your@email.com',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Subscribed! Check your email.'),
                        backgroundColor: kGreen,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreenDark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Subscribe',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
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

class _Occasion {
  final String name;
  final IconData icon;
  final Color color;
  const _Occasion(this.name, this.icon, this.color);
}

class _Collection {
  final String name;
  final String subtitle;
  final String image;
  const _Collection(this.name, this.subtitle, this.image);
}

class _Tip {
  final IconData icon;
  final String title;
  final String body;
  const _Tip(this.icon, this.title, this.body);
}

class _Testimonial {
  final String name;
  final String body;
  final int stars;
  const _Testimonial(this.name, this.body, this.stars);
}

class _BrandStat extends StatelessWidget {
  final String value;
  final String label;
  const _BrandStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

class _BrandStatDivider extends StatelessWidget {
  const _BrandStatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withValues(alpha: 0.3),
    );
  }
}
