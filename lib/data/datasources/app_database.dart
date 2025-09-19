import 'package:path/path.dart';
import 'package:programacion_movil/data/models/player.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
  static Database? _db;

  // Cambia a true en desarrollo para usar un archivo de DB distinto
  static const bool useDevDatabase = true;

  AppDatabase._internal();

  Future<Database> get database async {
    // Solo inicializar si no existe
    _db ??= await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'database_sqlite.db');

    // Solo eliminar en desarrollo o primera vez
    if (useDevDatabase) {
      await deleteDatabase(path);
      print('🗑️ Base de datos eliminada (modo desarrollo)');
    }

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Método para resetear la base de datos manualmente si es necesario
  Future<void> resetDatabase() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'database_sqlite.db');
    await deleteDatabase(path);
    print('🗑️ Base de datos reseteada manualmente');

    // La próxima llamada a database creará una nueva
  }

  Future<void> _onCreate(Database db, int version) async {
    print('📄 Creando tablas de la base de datos');

    await db.execute('''
      CREATE TABLE player (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        score INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE category (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE category_item (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES category (id) ON DELETE CASCADE
      )
    ''');

    print('✅ Tablas creadas exitosamente');
  }

  Future<List<Player>> getPlayers() async {
    try {
      final db = await database;
      final data = await db.query('player');
      print('📋 Obtenidos ${data.length} jugadores de la DB');

      return data
          .map(
            (e) => Player(
              id: e["id"] as int,
              name: e["name"] as String,
              score: e["score"] as int? ?? 0,
            ),
          )
          .toList();
    } catch (e) {
      print('❌ Error al obtener jugadores: $e');
      rethrow;
    }
  }

  Future<void> insertPlayers(List<String> players) async {
    try {
      final db = await database;
      print('💾 Insertando ${players.length} jugadores...');

      // Usar transacción para mejor rendimiento y consistencia
      await db.transaction((txn) async {
        for (var name in players) {
          if (name.trim().isNotEmpty) {
            await txn.insert('player', {'name': name.trim(), 'score': 0});
          }
        }
      });

      print('✅ Jugadores insertados exitosamente');
    } catch (e) {
      print('❌ Error al insertar jugadores: $e');
      rethrow;
    }
  }

  Future<void> insertCategory(String category) async {
    try {
      final db = await database;
      if (category.trim().isNotEmpty) {
        await db.insert('category', {'name': category.trim()});
        print('✅ Categoría "$category" insertada');
      }
    } catch (e) {
      print('❌ Error al insertar categoría: $e');
      rethrow;
    }
  }

  // Método para hacer queries directas (uso avanzado)
  Future<List<Map<String, Object?>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    try {
      final db = await database;
      return await db.rawQuery(sql, arguments);
    } catch (e) {
      print('❌ Error en query: $e');
      rethrow;
    }
  }

  // Método para cerrar la base de datos al final de la aplicación
  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
      print('🔒 Base de datos cerrada');
    }
  }
}
