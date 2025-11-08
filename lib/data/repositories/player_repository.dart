import '../datasources/app_database.dart';
import '../models/player.dart';

/// Repositorio para gestionar jugadores
/// Sigue el patrón de acceso indirecto a través de AppDatabase
class PlayerRepository {
  final AppDatabase _database = AppDatabase.instance;

  /// Inserta múltiples jugadores
  Future<void> insertPlayers(List<Player> players) async {
    await _database.insertPlayers(players);
  }

  /// Inserta un solo jugador
  Future<void> insertPlayer(Player player) async {
    await _database.insertPlayers([player]);
  }

  // Si necesitas más métodos relacionados con jugadores,
  // primero debes agregarlos a AppDatabase y luego exponerlos aquí
}