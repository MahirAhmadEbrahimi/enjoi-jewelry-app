import 'package:flutter/material.dart';
import '../services/cart_service.dart';

class CartDrawer extends StatefulWidget {
  const CartDrawer({super.key});

  @override
  State<CartDrawer> createState() => _CartDrawerState();
}

class _CartDrawerState extends State<CartDrawer> {
  static const Color kGreen = Color(0xFF2E7D32);
  static const Color kGreenDark = Color(0xFF1B5E20);
  static const Color kGreenLight = Color(0xFFE8F5E9);

  @override
  void initState() {
    super.initState();
    CartService.instance.addListener(_onChanged);
  }

  @override
  void dispose() {
    CartService.instance.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final items = CartService.instance.items;
    final total = CartService.instance.totalPrice;
    final width = MediaQuery.of(context).size.width;
    final drawerWidth = width < 480 ? width * 0.88 : 380.0;

    return Drawer(
      width: drawerWidth,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            _header(items.length),
            const Divider(height: 1),
            Expanded(
              child: items.isEmpty
                  ? _empty()
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _cartRow(items[i]),
                    ),
            ),
            if (items.isNotEmpty) _footer(total),
          ],
        ),
      ),
    );
  }

  Widget _header(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      child: Row(
        children: [
          const Icon(Icons.shopping_bag_outlined, color: kGreenDark),
          const SizedBox(width: 8),
          const Text(
            'My Cart',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kGreenDark,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: kGreenLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count/${CartService.maxItems}',
              style: const TextStyle(
                color: kGreenDark,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Spacer(),
          if (count > 0)
            TextButton(
              onPressed: () => CartService.instance.clear(),
              style: TextButton.styleFrom(foregroundColor: kGreen),
              child: const Text('Clear'),
            ),
          IconButton(
            icon: const Icon(Icons.close, color: kGreenDark),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: kGreenLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: kGreen,
              size: 48,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kGreenDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add up to ${CartService.maxItems} products.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _cartRow(CartItem item) {
    final p = item.product;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 64,
              height: 64,
              color: kGreenLight,
              child: Image.asset(
                p.image,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const Center(
                  child: Icon(Icons.diamond, color: kGreen, size: 28),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: kGreenDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  p.category,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 6),
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
                    _qtyBtn(Icons.remove, () {
                      CartService.instance.updateQuantity(
                        p.id,
                        item.quantity - 1,
                      );
                    }),
                    SizedBox(
                      width: 26,
                      child: Text(
                        '${item.quantity}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kGreenDark,
                        ),
                      ),
                    ),
                    _qtyBtn(Icons.add, () {
                      CartService.instance.updateQuantity(
                        p.id,
                        item.quantity + 1,
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            color: Colors.grey.shade500,
            onPressed: () => CartService.instance.remove(p.id),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: kGreen,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: Colors.white, size: 14),
      ),
    );
  }

  Widget _footer(double total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.green.shade100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 14,
                  color: kGreenDark,
                  fontWeight: FontWeight.w600,
                ),
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
          const SizedBox(height: 10),
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Checkout coming soon'),
                    backgroundColor: kGreen,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.lock_outline, size: 18),
              label: const Text(
                'Checkout',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
