import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../Screens/product_screen.dart';

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, required this.quantity});
}

class CartService extends ChangeNotifier {
  CartService._();
  static final CartService instance = CartService._();

  static const int maxItems = 5;
  static const String _dbBase =
      'https://jewelryapp-69ec8-default-rtdb.firebaseio.com';

  final Map<int, CartItem> _items = {};
  bool _loaded = false;

  List<CartItem> get items => _items.values.toList();
  int get count => _items.length;
  int get totalQuantity =>
      _items.values.fold(0, (s, it) => s + it.quantity);
  double get totalPrice => _items.values.fold(
        0,
        (s, it) => s + it.product.price * it.quantity,
      );
  bool get isLoaded => _loaded;

  /// Returns the id of the evicted product if the oldest item was removed
  /// to make room (only when adding a NEW product and cart is already full).
  int? add(Product p, int qty) {
    int? evicted;
    if (_items.containsKey(p.id)) {
      _items[p.id]!.quantity = qty;
      _remoteUpsert(p, qty);
    } else {
      if (_items.length >= maxItems) {
        final oldestId = _items.keys.first;
        _items.remove(oldestId);
        evicted = oldestId;
        _remoteRemove(oldestId);
      }
      _items[p.id] = CartItem(product: p, quantity: qty);
      _remoteUpsert(p, qty);
    }
    notifyListeners();
    return evicted;
  }

  void remove(int id) {
    if (_items.remove(id) != null) {
      notifyListeners();
      _remoteRemove(id);
    }
  }

  void updateQuantity(int id, int qty) {
    final item = _items[id];
    if (item == null) return;
    if (qty <= 0) {
      remove(id);
      return;
    }
    item.quantity = qty;
    notifyListeners();
    _remoteUpsert(item.product, qty);
  }

  void clear() {
    final ids = _items.keys.toList();
    _items.clear();
    notifyListeners();
    for (final id in ids) {
      _remoteRemove(id);
    }
  }

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> load() async {
    final uid = _uid;
    if (uid == null) {
      _loaded = true;
      return;
    }
    try {
      final url = Uri.parse('$_dbBase/jewelryapp/cart/$uid.json');
      final res = await http.get(url);
      if (res.statusCode == 200 && res.body.isNotEmpty && res.body != 'null') {
        final data = jsonDecode(res.body);
        if (data is Map) {
          _items.clear();
          data.forEach((_, v) {
            if (v is Map) {
              final p = Product(
                id: (v['id'] as num).toInt(),
                name: v['name'] as String,
                price: (v['price'] as num).toDouble(),
                image: v['image'] as String,
                category: v['category'] as String,
              );
              _items[p.id] = CartItem(
                product: p,
                quantity: (v['quantity'] as num).toInt(),
              );
            }
          });
          notifyListeners();
        }
      }
    } catch (_) {}
    _loaded = true;
  }

  Future<void> _remoteUpsert(Product p, int qty) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      final url = Uri.parse('$_dbBase/jewelryapp/cart/$uid/${p.id}.json');
      await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': p.id,
          'name': p.name,
          'price': p.price,
          'image': p.image,
          'category': p.category,
          'quantity': qty,
        }),
      );
    } catch (_) {}
  }

  Future<void> _remoteRemove(int id) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      final url = Uri.parse('$_dbBase/jewelryapp/cart/$uid/$id.json');
      await http.delete(url);
    } catch (_) {}
  }
}
