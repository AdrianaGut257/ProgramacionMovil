import '../datasources/app_database.dart';

class CategoryRepository {
  final AppDatabase _database = AppDatabase.instance;

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    return await _database.getCategories();
  }

  Future<List<Map<String, dynamic>>> getDefaultCategories() async {
    return await _database.getDefaultCategories();
  }

  Future<List<Map<String, dynamic>>> getCustomCategories() async {
    return await _database.getCustomCategories();
  }

  Future<void> addCategory(String name) async {
    await _database.insertCategory(name);
  }
}
