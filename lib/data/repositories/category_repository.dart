import '../datasources/app_database.dart';

/// Repositorio para gestionar categorías
/// Sigue el patrón de acceso indirecto a través de AppDatabase
class CategoryRepository {
  final AppDatabase _database = AppDatabase.instance;

  /// Obtiene todas las categorías
  Future<List<Map<String, dynamic>>> getAllCategories() async {
    return await _database.getCategories();
  }

  /// Obtiene solo las categorías predeterminadas
  Future<List<Map<String, dynamic>>> getDefaultCategories() async {
    return await _database.getDefaultCategories();
  }

  /// Obtiene solo las categorías personalizadas
  Future<List<Map<String, dynamic>>> getCustomCategories() async {
    return await _database.getCustomCategories();
  }

  /// Agrega una nueva categoría personalizada
  Future<void> addCategory(String name) async {
    await _database.insertCategory(name);
  }

  /// Elimina una categoría por nombre
  Future<void> deleteCategory(String name) async {
    await _database.deleteCategory(name);
  }

  /// Verifica si existe una categoría
  Future<bool> categoryExists(String name) async {
    final all = await getAllCategories();
    return all.any((cat) => cat['name'] == name);
  }

  /// Cuenta el total de categorías
  Future<int> getTotalCount() async {
    final all = await getAllCategories();
    return all.length;
  }

  /// Cuenta categorías personalizadas
  Future<int> getCustomCount() async {
    final custom = await getCustomCategories();
    return custom.length;
  }
}