import 'package:flutter/material.dart';
import 'package:programacion_movil/features/presentation/widgets/category/styles/text_styles.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/add_remove_button.dart';

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
  final Map<String, IconData> allPredCategories = {
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

  Widget _categoryCard(String category, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Card(
            color: const Color(0xFF524BBB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 20),
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
          ),
        ),
        const SizedBox(width: 8),
        AddRemoveButton(
          isAdd: true,
          onPressed: () => widget.onToggle(category),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filtrar solo las categorías predeterminadas NO seleccionadas
    final availableCategories = allPredCategories.entries
        .where((entry) => !widget.selectedCategories.contains(entry.key))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Categorías predeterminadas disponibles",
            style: categorySubtitleStyle,
          ),
          const SizedBox(height: 15),
          Expanded(
            child: availableCategories.isEmpty
                ? Center(
                    child: Text(
                      "Todas las categorías predeterminadas\nhan sido seleccionadas",
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
                      final entry = availableCategories[index];
                      return _categoryCard(entry.key, entry.value);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
