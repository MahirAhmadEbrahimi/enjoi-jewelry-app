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

  final List<String> _ringSizes = const [
    '5.0',
    '5.5',
    '6.0',
    '6.5',
    '7.0',
    '7.5',
  ];

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final total = p.price * _quantity;
    final needsSize = p.category == 'Rings' || p.category == 'Bracelets';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 340,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Hero(
                              tag: 'product-${p.id}',
                              child: Container(
                                color: kGreenLight,
                                child: Image.asset(
                                  p.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => const Center(
                                    child: Icon(
                                      Icons.diamond,
                                      color: kGreen,
                                      size: 80,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: _circleIconButton(
                              Icons.arrow_back_ios_new,
                              () => Navigator.pop(context),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: _circleIconButton(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              () => setState(() => _isFavorite = !_isFavorite),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _details(p, needsSize, total),
                  ],
                ),
              ),
            ),
            _bottomBar(p, total),
          ],
        ),
      ),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
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
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: kGreen, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'In Stock',
                      style: TextStyle(
                        color: kGreenDark,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            p.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kGreenDark,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${p.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: kGreen,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '\$${(p.price * 1.25).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '-20%',
                    style: TextStyle(
                      color: Color(0xFFC62828),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 8,
            children: [
              _infoChip(
                Icons.star_rounded,
                '4.8 (128 reviews)',
                const Color(0xFFF5B400),
              ),
              _infoChip(Icons.local_shipping_outlined, 'Free shipping', kGreen),
              _infoChip(Icons.verified_outlined, 'Authentic', kGreen),
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
          const SizedBox(height: 18),
          const Text(
            'Specifications',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: kGreenDark,
            ),
          ),
          const SizedBox(height: 8),
          _specRow('Material', _materialFor(p.category)),
          _specRow('Category', p.category),
          _specRow('SKU', 'ENJ-${p.id.toString().padLeft(4, '0')}'),
          _specRow('Warranty', '1 Year'),
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
                _quantity > 1 ? () => setState(() => _quantity--) : null,
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

  Widget _infoChip(IconData icon, String text, Color iconColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: kGreenDark,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _specRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: kGreenDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _materialFor(String category) {
    switch (category) {
      case 'Rings':
        return '18K Gold with Diamond';
      case 'Earrings':
        return '925 Sterling Silver';
      case 'Necklaces':
        return '18K Gold Plated';
      case 'Bracelets':
        return 'Rose Gold with Gemstones';
      default:
        return 'Premium Alloy';
    }
  }

  Widget _bottomBar(Product p, double total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.green.shade100)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
