import 'package:flutter/material.dart';
import 'package:programacion_movil/features/presentation/widgets/category/styles/text_styles.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/add_remove_button.dart';

class SelectedCategory extends StatelessWidget {
  final List<String> selectedCategories;
  final void Function(String) onToggle;

  const SelectedCategory({
    super.key,
    required this.selectedCategories,
    required this.onToggle,
  });

  IconData _getCategoryIcon(String category) {
    final iconMap = {
      "Música": Icons.music_note,
      "Animales": Icons.pets,
      "Países": Icons.flag,
      "Frutas": Icons.apple,
      "Vegetales": Icons.eco,
      "Apellidos": Icons.person,
      "Colores": Icons.palette,
      "Profesiones": Icons.work,
      "Ropa": Icons.checkroom,
      "Peliculas": Icons.movie,
      "Comidas": Icons.restaurant,
      "Canciones": Icons.queue_music,
    };
    return iconMap[category] ?? Icons.label;
  }

  Widget _categoryCard(String category) {
    return Card(
      color: const Color(0xFF524BBB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getCategoryIcon(category), color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                category,
                style: const TextStyle(color: Colors.white, fontSize: 18),
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
            "Todas tus categorías seleccionadas",
            style: categorySubtitleStyle,
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
