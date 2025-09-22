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
  final List<String> predCategories = [
    "Colores",
    "Profesiones",
    "Ropa",
    "Peliculas",
    "Comidas",
    "Canciones",
  ];

  Widget _childListPadding(String category, bool buttonState) {
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
          isAdd: !buttonState,
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
          Text("Categorias Seleccionadas", style: categorySubtitleStyle),
          const SizedBox(height: 15),
          Expanded(
            flex: 1,
            child: widget.selectedCategories.isEmpty
                ? Center(
                    child: Text(
                      "No hay categorías seleccionadas",
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.selectedCategories.length,
                    itemBuilder: (context, index) {
                      final category = widget.selectedCategories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: _childListPadding(category, true),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 15),
          Text("Añade más categorias!", style: categorySubtitleStyle),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: predCategories.length,
              itemBuilder: (context, index) {
                final category = predCategories[index];
                final isSelected = widget.selectedCategories.contains(category);
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
