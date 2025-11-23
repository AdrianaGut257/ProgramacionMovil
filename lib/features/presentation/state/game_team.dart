import 'package:flutter/foundation.dart';
import '../../../data/models/player.dart';
import '../../../data/models/category.dart' as models;

class GameTeam extends ChangeNotifier {
  final List<Player> _players = [];
  final List<models.Category> _categories = [];
  final List<String> _selectedWildcards = [];

  List<Player> get players => List.unmodifiable(_players);
  List<models.Category> get categories => List.unmodifiable(_categories);
  List<String> get selectedWildcards => List.unmodifiable(_selectedWildcards);

  void addPlayer(Player player) {
    _players.add(player);
    notifyListeners();
  }

  void updatePlayerScore(int playerId, int newScore) {
    final index = _players.indexWhere((p) => p.id == playerId);
    if (index != -1) {
      _players[index] = Player(
        id: _players[index].id,
        name: _players[index].name,
        score: newScore,
        team: _players[index].team,
      );
      notifyListeners();
    }
  }

  void setCategories(List<models.Category> selectedCategories) {
    _categories
      ..clear()
      ..addAll(selectedCategories);
    notifyListeners();
  }

  void addCategory(models.Category category) {
    _categories.add(category);
    notifyListeners();
  }

  void setWildcards(List<String> wildcards) {
    _selectedWildcards
      ..clear()
      ..addAll(wildcards);
    notifyListeners();
  }

  void addWildcard(String wildcard) {
    if (!_selectedWildcards.contains(wildcard)) {
      _selectedWildcards.add(wildcard);
      notifyListeners();
    }
  }

  void removeWildcard(String wildcard) {
    _selectedWildcards.remove(wildcard);
    notifyListeners();
  }

  void clearWildcards() {
    _selectedWildcards.clear();
    notifyListeners();
  }

  void clearPlayers() {
    _players.clear();
    notifyListeners();
  }

  void clearCategories() {
    _categories.clear();
    notifyListeners();
  }

  void clearAll() {
    _players.clear();
    _categories.clear();
    _selectedWildcards.clear();
    notifyListeners();
  }
}
