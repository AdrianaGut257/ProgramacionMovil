import 'package:flutter/material.dart';
import 'package:programacion_movil/features/presentation/pages/category/styles/text_styles.dart';

class CreateCategory extends StatefulWidget {
  final void Function(String categoryName) onCategoryCreated;
  const CreateCategory({super.key, required this.onCategoryCreated});

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveCategory() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    widget.onCategoryCreated(name);
    _nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Text('Crea tu categoria', style: categoryTitleStyle),

          const SizedBox(height: 15),

          Row(
            children: [
              SizedBox(
                width: 150,
                height: 45,
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  textAlignVertical:
                      TextAlignVertical.center, // ✅ Centrado vertical
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
          ),
          // Campo de texto
        ],
      ),
    );
  }
}
