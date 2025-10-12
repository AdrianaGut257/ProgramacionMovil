import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:programacion_movil/data/repositories/category_repository.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/add_remove_button.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final CategoryRepository _repository = CategoryRepository();
  final TextEditingController _nameController = TextEditingController();
  final List<String> _customCategories = [];
  bool _isLoading = true;

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

  Future<void> _loadCategories() async {
    try {
      final categories = await _repository.getCustomCategories();
      setState(() {
        _customCategories.clear();
        _customCategories.addAll(
          categories.map((c) => c['name'] as String).toList(),
        );
        _isLoading = false;
      });

      if (kDebugMode) {
        print("Categorías personalizadas cargadas: $_customCategories");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (kDebugMode) {
        print("Error al cargar categorías: $e");
      }
    }
  }

  Future<void> _saveCategory() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre no puede estar vacío')),
      );
      return;
    }

    final allCategories = await _repository.getAllCategories();
    final allNames = allCategories.map((c) => c['name'] as String).toList();

    if (allNames.contains(name)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La categoría "$name" ya existe')),
        );
      }
      return;
    }

    await _repository.addCategory(name);

    setState(() {
      _customCategories.add(name);
      _nameController.clear();
    });

    if (kDebugMode) {
      print("Categoría guardada: $name");
    }
  }

  Widget _inputField() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.primaryVariant,
        borderRadius: BorderRadius.circular(25),
        border: Border(
          bottom: BorderSide(color: AppColors.primaryVariant, width: 4),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(25),
          border: Border(
            bottom: BorderSide(color: AppColors.primaryVariant, width: 3),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  hintText: 'Escribe aquí',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(
                    Icons.category_outlined,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 9),
              child: AddRemoveButton(isAdd: true, onPressed: _saveCategory),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard(String category, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryVariant,
        borderRadius: BorderRadius.circular(25),
        border: Border(
          bottom: BorderSide(color: AppColors.primaryVariant, width: 4),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(25),
          border: Border(
            bottom: BorderSide(color: AppColors.primaryVariant, width: 3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            top: 12,
            bottom: 12,
            right: 9,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.label, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 50),
              AddRemoveButton(
                isAdd: !isSelected,
                onPressed: () => widget.onToggle(category),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Crea tu categoría',
            style: GoogleFonts.titanOne().copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              letterSpacing: 0,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 15),
          _inputField(),
          const SizedBox(height: 30),
          Text(
            "Tus categorías creadas",
            style: GoogleFonts.titanOne().copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              letterSpacing: 0,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _customCategories.isEmpty
                ? const Center(
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
                    itemCount: _customCategories.length,
                    itemBuilder: (context, index) {
                      final category = _customCategories[index];
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
