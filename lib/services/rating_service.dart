import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RatingService extends ChangeNotifier {
  RatingService._();
  static final RatingService instance = RatingService._();

  static const String _dbBase =
      'https://jewelryapp-69ec8-default-rtdb.firebaseio.com';

  // productId -> { uid -> stars (1..5) }
  final Map<int, Map<String, int>> _ratings = {};
  bool _loaded = false;
  bool _loading = false;

  bool get isLoaded => _loaded;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  double averageFor(int productId) {
    final map = _ratings[productId];
    if (map == null || map.isEmpty) return 0.0;
    final sum = map.values.fold<int>(0, (a, b) => a + b);
    return sum / map.length;
  }

  int countFor(int productId) => _ratings[productId]?.length ?? 0;

  int? myRatingFor(int productId) {
    final uid = _uid;
    if (uid == null) return null;
    return _ratings[productId]?[uid];
  }

  Future<void> load() async {
    if (_loading) return;
    _loading = true;
    try {
      final url = Uri.parse('$_dbBase/jewelryapp/ratings.json');
      final res = await http.get(url);
      if (res.statusCode == 200 && res.body.isNotEmpty && res.body != 'null') {
        final data = jsonDecode(res.body);
        if (data is Map) {
          _ratings.clear();
          data.forEach((pidStr, users) {
            final pid = int.tryParse(pidStr.toString());
            if (pid == null || users is! Map) return;
            final m = <String, int>{};
            users.forEach((uid, stars) {
              if (stars is num) m[uid.toString()] = stars.toInt();
            });
            _ratings[pid] = m;
          });
          notifyListeners();
        }
      }
    } catch (_) {
      // ignore network errors
    }
    _loaded = true;
    _loading = false;
  }

  /// Returns null on success, or an error message.
  Future<String?> rate(int productId, int stars) async {
    if (stars < 1 || stars > 5) return 'Rating must be between 1 and 5';
    final uid = _uid;
    if (uid == null) return 'Please log in to rate this product';
    _ratings.putIfAbsent(productId, () => {})[uid] = stars;
    notifyListeners();
    try {
      final url = Uri.parse(
        '$_dbBase/jewelryapp/ratings/$productId/$uid.json',
      );
      final res = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(stars),
      );
      if (res.statusCode >= 400) {
        return 'Failed to save rating (${res.statusCode})';
      }
    } catch (e) {
      return 'Network error while saving rating';
    }
    return null;
  }
}
