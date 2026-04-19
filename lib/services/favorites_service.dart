import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../Screens/product_screen.dart';

class FavoritesService extends ChangeNotifier {
  FavoritesService._();
  static final FavoritesService instance = FavoritesService._();

  static const String _dbBase =
      'https://jewelryapp-69ec8-default-rtdb.firebaseio.com';

  final Map<int, Product> _items = {};
  bool _loaded = false;

  List<Product> get items => _items.values.toList();
  int get count => _items.length;
  bool contains(int id) => _items.containsKey(id);

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> toggle(Product p) async {
    if (_items.containsKey(p.id)) {
      _items.remove(p.id);
      notifyListeners();
      await _remoteRemove(p.id);
    } else {
      _items[p.id] = p;
      notifyListeners();
      await _remoteAdd(p);
    }
  }

  Future<void> load() async {
    final uid = _uid;
    if (uid == null) {
      _loaded = true;
      return;
    }
    try {
      final url = Uri.parse('$_dbBase/jewelryapp/favorites/$uid.json');
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
              _items[p.id] = p;
            }
          });
          notifyListeners();
        }
      }
    } catch (_) {
      // ignore network errors, keep local state
    }
    _loaded = true;
  }

  bool get isLoaded => _loaded;

  Future<void> _remoteAdd(Product p) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      final url = Uri.parse(
        '$_dbBase/jewelryapp/favorites/$uid/${p.id}.json',
      );
      await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': p.id,
          'name': p.name,
          'price': p.price,
          'image': p.image,
          'category': p.category,
        }),
      );
    } catch (_) {
      // ignore
    }
  }

  Future<void> _remoteRemove(int id) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      final url = Uri.parse('$_dbBase/jewelryapp/favorites/$uid/$id.json');
      await http.delete(url);
    } catch (_) {
      // ignore
    }
  }
}
