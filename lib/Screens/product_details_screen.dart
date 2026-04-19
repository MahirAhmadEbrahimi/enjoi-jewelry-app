import 'package:flutter/material.dart';
import 'product_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  static const Color kGreen = Color(0xFF2E7D32);
  static const Color kGreenDark = Color(0xFF1B5E20);
  static const Color kGreenLight = Color(0xFFE8F5E9);

  int _quantity = 1;
  int _sizeIndex = 2;
  bool _isFavorite = false;

  final List<String> _ringSizes = const ['5.0', '5.5', '6.0', '6.5', '7.0', '7.5'];

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final total = p.price * _quantity;
    final needsSize = p.category == 'Rings' || p.category == 'Bracelets';

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: kGreenDark,
            elevation: 0,
            leading: _circleIconButton(
              Icons.arrow_back_ios_new,
              () => Navigator.pop(context),
            ),
            actions: [
              _circleIconButton(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                () => setState(() => _isFavorite = !_isFavorite),
              ),
              const SizedBox(width: 12),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${p.id}',
                child: Container(
                  color: kGreenLight,
                  child: Image.asset(
                    p.image,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Center(
                      child: Icon(Icons.diamond, color: kGreen, size: 80),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _details(p, needsSize, total)),
        ],
      ),
      bottomNavigationBar: _bottomBar(p, total),
    );
  }

  Widget _circleIconButton(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: kGreenDark, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _details(Product p, bool needsSize, double total) {
    return Container(
      transform: Matrix4.translationValues(0, -20, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: kGreenLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              p.category,
              style: const TextStyle(
                color: kGreenDark,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  p.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: kGreenDark,
                  ),
                ),
              ),
              Text(
                '\$${p.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Color(0xFFF5B400), size: 20),
              const SizedBox(width: 4),
              const Text(
                '4.8',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(width: 6),
              Text(
                '(128 reviews)',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const Spacer(),
              const Icon(
                Icons.local_shipping_outlined,
                color: kGreen,
                size: 18,
              ),
              const SizedBox(width: 4),
              const Text(
                'Free shipping',
                style: TextStyle(
                  color: kGreenDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: kGreenDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Our ${p.name.toLowerCase()} is a stunning piece, handcrafted with premium materials and attention to detail. '
            'Perfect for special occasions or as an everyday statement piece — timeless elegance that lasts forever.',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          if (needsSize) ...[
            const SizedBox(height: 22),
            const Text(
              'Select Size',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: kGreenDark,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_ringSizes.length, (i) {
                final selected = i == _sizeIndex;
                return GestureDetector(
                  onTap: () => setState(() => _sizeIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 56,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? kGreen : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected ? kGreen : Colors.green.shade100,
                        width: 1.4,
                      ),
                    ),
                    child: Text(
                      _ringSizes[i],
                      style: TextStyle(
                        color: selected ? Colors.white : kGreenDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
          const SizedBox(height: 22),
          Row(
            children: [
              const Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: kGreenDark,
                ),
              ),
              const Spacer(),
              _qtyButton(
                Icons.remove,
                _quantity > 1
                    ? () => setState(() => _quantity--)
                    : null,
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '$_quantity',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: kGreenDark,
                  ),
                ),
              ),
              _qtyButton(Icons.add, () => setState(() => _quantity++)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback? onTap) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: enabled ? kGreen : Colors.green.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _bottomBar(Product p, double total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.green.shade100)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 18),
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _addToCart(p),
                  icon: const Icon(Icons.shopping_bag_outlined, size: 20),
                  label: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(Product p) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$_quantity × ${p.name} added to cart',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
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
  }
}
