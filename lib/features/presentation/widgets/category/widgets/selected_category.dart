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
                color: AppColors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  category,
                  style: const TextStyle(color: AppColors.white, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 28),
              AddRemoveButton(
                isAdd: false,
                onPressed: () => onToggle(category),
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
                      style: TextStyle(color: AppColors.grey, fontSize: 20),
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
                      return _categoryCard(category);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
