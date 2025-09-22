//import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:programacion_movil/data/datasources/app_database.dart';
import 'package:programacion_movil/features/presentation/pages/category/styles/text_styles.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/add_remove_button.dart';

class CreateCategory extends StatefulWidget {
  final void Function(String categoryName) onCategoryCreated;
  final void Function(List<String> selectedCategories)? onSelectionChanged;

  const CreateCategory({
    super.key,
    required this.onCategoryCreated,
    this.onSelectionChanged,
  });

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> _selectedCategories = [];
  final List<String> _createdCategories = [
    "Deportes",
    "Tecnología",
    "Música",
    "Cine",
    "Juegos",
    "Bebidas",
    "Furbo",
  ];
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveCategory() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    //final db = await AppDatabase.instance.database;

    widget.onCategoryCreated(name);
    _nameController.clear();
    _createdCategories.add(name);
    await AppDatabase.instance.insertCategory(name);

    if (kDebugMode) {
      print("este es la categoria: $name");
    }
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });

    widget.onSelectionChanged?.call(List.from(_selectedCategories));
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
            textAlignVertical: TextAlignVertical.center, // ✅ Centrado vertical
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF615AC7),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 12,
              ), // 🔧 Ajusta el padding
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
        const SizedBox(width: 15), // Espacio entre el campo y el botón
        SizedBox(
          width: 45,
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF28D4B1),
              padding: EdgeInsets
                  .zero, // Elimina el padding para que SizedBox controle el tamaño
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
          onPressed: () => _toggleCategory(category),
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
          // Título
          Text('Crea tu categoria', style: categorySubtitleStyle),
          const SizedBox(height: 15),
          _inputField(),
          const SizedBox(height: 45),
          Text("Tus categorias creadas", style: categorySubtitleStyle),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _createdCategories.length,
              itemBuilder: (context, index) {
                final category = _createdCategories[index];
                final isSelected = _selectedCategories.contains(category);
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
