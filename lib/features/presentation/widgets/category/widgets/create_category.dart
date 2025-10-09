import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:programacion_movil/data/datasources/app_database.dart';
import 'package:programacion_movil/features/presentation/widgets/category/styles/text_styles.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/add_remove_button.dart';
import 'package:programacion_movil/config/colors.dart';

class CreateCategory extends StatefulWidget {
  final List<String> selectedCategories;
  final void Function(String) onToggle;

  const CreateCategory({
    super.key,
    required this.selectedCategories,
    required this.onToggle,
  });

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> _createdCategories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Cargar categorías desde la base de datos
  Future<void> _loadCategories() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query("category");
    final categories = result.map((e) => e['name'] as String).toList();

    setState(() {
      _createdCategories.clear();
      _createdCategories.addAll(categories);
    });

    if (kDebugMode) {
      print("Categorías cargadas: $_createdCategories");
    }
  }

  /// Guardar nueva categoría
  Future<void> _saveCategory() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    if (_createdCategories.contains(name)) {
      if (kDebugMode) {
        print("La categoría '$name' ya existe");
      }
      return;
    }

    await AppDatabase.instance.insertCategory(name);

    setState(() {
      _createdCategories.add(name);
      _nameController.clear();
    });

    if (kDebugMode) {
      print("Categoría guardada: $name");
    }
  }

  Widget _inputField() {
    return Row(
      children: [
        SizedBox(
          width: 280,
          height: 45,
          child: TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white, fontSize: 20),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.primary,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primaryVariant,
                  width: 4,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        AddRemoveButton(isAdd: true, onPressed: _saveCategory),
      ],
    );
  }

  Widget _categoryCard(String category, bool isSelected) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Card(
            color: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.label, color: Colors.white, size: 18),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      category,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        AddRemoveButton(
          isAdd: !isSelected,
          onPressed: () => widget.onToggle(category),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Crea tu categoría', style: categorySubtitleStyle),
          const SizedBox(height: 15),
          _inputField(),
          const SizedBox(height: 30),
          Text("Tus categorías creadas", style: categorySubtitleStyle),
          const SizedBox(height: 15),
          Expanded(
            child: _createdCategories.isEmpty
                ? Center(
                    child: Text(
                      "No hay categorías creadas aún",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: _createdCategories.length,
                    itemBuilder: (context, index) {
                      final category = _createdCategories[index];
                      final isSelected = widget.selectedCategories.contains(
                        category,
                      );
                      return _categoryCard(category, isSelected);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
