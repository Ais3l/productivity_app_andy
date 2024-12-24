import 'package:flutter/foundation.dart';

class CoinsProvider with ChangeNotifier {
  int _coins = 100;
  int _treesPlanted = 0;

  int get coins => _coins;
  int get treesPlanted => _treesPlanted;

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

  void plantTree() {
    _treesPlanted += 1;
    notifyListeners();
  }
}
