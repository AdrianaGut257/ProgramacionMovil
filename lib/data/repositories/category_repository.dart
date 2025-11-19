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

  Future<void> deleteCategory(String name) async {
    await _database.deleteCategory(name);
  }

  Future<bool> categoryExists(String name) async {
    final all = await getAllCategories();
    return all.any((cat) => cat['name'] == name);
  }

  Future<int> getTotalCount() async {
    final all = await getAllCategories();
    return all.length;
  }

  Future<int> getCustomCount() async {
    final custom = await getCustomCategories();
    return custom.length;
  }
}
