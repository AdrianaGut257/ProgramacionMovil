import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:programacion_movil/data/datasources/app_database.dart';
import 'package:programacion_movil/features/presentation/widgets/category/styles/text_styles.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/add_remove_button.dart';

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
          width: 150,
          height: 45,
          child: TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white, fontSize: 20),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF615AC7),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF524BBB),
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
        SizedBox(
          width: 45,
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF28D4B1),
              padding: EdgeInsets.zero,
              shape: const CircleBorder(
                side: BorderSide(color: Color(0xFF1EA58A), width: 2),
              ),
            ),
            onPressed: _saveCategory,
            child: const Icon(Icons.add, color: Colors.white, size: 35),
          ),
        ),
      ],
    );
  }

  Widget _childListPadding(String category, bool isSelected) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          color: const Color(0xFF524BBB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              category,
              style: const TextStyle(color: Colors.white, fontSize: 18),
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
          const SizedBox(height: 45),
          Text("Tus categorías creadas", style: categorySubtitleStyle),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _createdCategories.length,
              itemBuilder: (context, index) {
                final category = _createdCategories[index];
                final isSelected =
                    widget.selectedCategories.contains(category);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: _childListPadding(category, isSelected),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
