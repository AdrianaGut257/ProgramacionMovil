import 'package:flutter/material.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/add_remove_button.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/config/icons.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectedCategory extends StatelessWidget {
  final List<String> selectedCategories;
  final void Function(String) onToggle;

  const SelectedCategory({
    super.key,
    required this.selectedCategories,
    required this.onToggle,
  });

  Widget _categoryCard(String category) {
    return Card(
      color: AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(GlobalIcons.getIcon(category), color: Colors.white, size: 18),
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
            "Todas tus categorías seleccionadas para jugar",
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
            child: selectedCategories.isEmpty
                ? Center(
                    child: Text(
                      "No hay categorías seleccionadas",
                      style: TextStyle(color: Colors.grey, fontSize: 20),
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
                    itemCount: selectedCategories.length,
                    itemBuilder: (context, index) {
                      final category = selectedCategories[index];
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(child: _categoryCard(category)),
                          const SizedBox(width: 8),
                          AddRemoveButton(
                            isAdd: false,
                            onPressed: () => onToggle(category),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
