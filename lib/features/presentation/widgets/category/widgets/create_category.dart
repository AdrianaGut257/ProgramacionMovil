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
  final List<String> _customCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void didUpdateWidget(CreateCategory oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategories != widget.selectedCategories) {
      _loadCategories();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _repository.getCustomCategories();

      if (!mounted) return;

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
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
      if (kDebugMode) {
        print("Error al cargar categorías: $e");
      }
    }
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.label, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 4),
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
    final availableCategories = _customCategories
        .where((category) => !widget.selectedCategories.contains(category))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                : availableCategories.isEmpty
                ? Center(
                    child: Text(
                      _customCategories.isEmpty
                          ? "No hay categorías creadas aún"
                          : "Todas las categorías creadas han sido seleccionada",
                      style: const TextStyle(color: Colors.grey, fontSize: 18),
                      textAlign: TextAlign.center,
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
                    itemCount: availableCategories.length,
                    itemBuilder: (context, index) {
                      final category = availableCategories[index];
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
