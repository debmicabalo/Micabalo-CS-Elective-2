import 'package:flutter/foundation.dart';
import 'products.dart';

class CartController extends ChangeNotifier {
  final Map<Product, int> _items = {};

  Map<Product, int> get items => Map.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  int get itemCount =>
      _items.values.fold(0, (total, quantity) => total + quantity);

  double get total => _items.entries.fold(
        0,
        (total, entry) => total + (entry.key.price * entry.value),
      );

  void add(Product product) {
    _items[product] = (_items[product] ?? 0) + 1;
    notifyListeners();
  }

  void increase(Product product) {
    add(product);
  }

  void decrease(Product product) {
    if (!_items.containsKey(product)) return;

    final quantity = _items[product]!;

    if (quantity <= 1) {
      _items.remove(product);
    } else {
      _items[product] = quantity - 1;
    }

    notifyListeners();
  }

  void remove(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}