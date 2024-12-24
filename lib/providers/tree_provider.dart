import 'package:flutter/foundation.dart';

class TreeProvider with ChangeNotifier {
  int _selectedTreeIndex = 0;

  int get selectedTreeIndex => _selectedTreeIndex;

  void setSelectedTree(int index) {
    _selectedTreeIndex = index;
    notifyListeners();
  }
}
