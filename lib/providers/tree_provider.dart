import 'package:flutter/foundation.dart';

class TreeProvider with ChangeNotifier {
  final List<bool> _unlockedTrees =
      List.generate(10, (index) => index == 0); // First tree unlocked
  int _selectedTreeIndex = 0;

  List<bool> get unlockedTrees => _unlockedTrees;

  int get selectedTreeIndex => _selectedTreeIndex;

  void unlockTree(int index) {
    if (index < _unlockedTrees.length) {
      _unlockedTrees[index] = true;
      notifyListeners();
    }
  }

  void setSelectedTree(int index) {
    if (index < _unlockedTrees.length && _unlockedTrees[index]) {
      _selectedTreeIndex = index;
      notifyListeners();
    }
  }
}
