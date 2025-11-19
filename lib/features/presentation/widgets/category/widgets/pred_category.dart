import 'package:flutter/material.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/add_remove_button.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/config/icons.dart';
import 'package:programacion_movil/data/repositories/category_repository.dart';
import 'package:google_fonts/google_fonts.dart';

class PredCategory extends StatefulWidget {
  final List<String> selectedCategories;
  final void Function(String) onToggle;

  const PredCategory({
    super.key,
    required this.selectedCategories,
    required this.onToggle,
  });

  @override
  State<PredCategory> createState() => _PredCategoryState();
}

class _PredCategoryState extends State<PredCategory> {
  final CategoryRepository _repository = CategoryRepository();
  List<String> _defaultCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _repository.getDefaultCategories();
      setState(() {
        _defaultCategories = categories
            .map((c) => c['name'] as String)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar categorías: $e')),
        );
      }
    }
  }

  Widget _categoryCard(String category) {
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                GlobalIcons.getIcon(category),
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  category,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 15),
              AddRemoveButton(
                isAdd: true,
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final availableCategories = _defaultCategories
        .where((category) => !widget.selectedCategories.contains(category))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Categorías predeterminadas disponibles",
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              height: 1.5,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Expanded(
            child: availableCategories.isEmpty
                ? const Center(
                    child: Text(
                      "Todas las categorías predeterminadas han sido seleccionadas",
                      textAlign: TextAlign.center,
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
                    itemCount: availableCategories.length,
                    itemBuilder: (context, index) {
                      return _categoryCard(availableCategories[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
