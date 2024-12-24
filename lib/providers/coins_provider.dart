import 'package:flutter/foundation.dart';

class CoinsProvider with ChangeNotifier {
  int _coins = 100;

  int get coins => _coins;

  void addCoins(int amount) {
    _coins += amount;
    notifyListeners();
  }

  void spendCoins(int amount) {
    if (_coins >= amount) {
      _coins -= amount;
      notifyListeners();
    }
  }
}
