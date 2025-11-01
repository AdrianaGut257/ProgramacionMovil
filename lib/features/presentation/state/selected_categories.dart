import 'package:flutter/foundation.dart';

class SelectedCategories extends ChangeNotifier {
  final List<String> _selectedCategories = [
    "Musica",
    "Animales",
    "Paises",
    "Frutas",
    "Vegetales",
    "Colores",
  ];

  List<String> get categories => List.unmodifiable(_selectedCategories);

  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  void addCategory(String category) {
    if (!_selectedCategories.contains(category)) {
      _selectedCategories.add(category);
      notifyListeners();
    }
  }

  void removeCategory(String category) {
    _selectedCategories.remove(category);
    notifyListeners();
  }

  bool isSelected(String category) {
    return _selectedCategories.contains(category);
  }

  void clearAll() {
    _selectedCategories.clear();
    notifyListeners();
  }
}
