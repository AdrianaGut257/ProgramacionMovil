import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // ⬅️ Agregar

import 'package:programacion_movil/features/presentation/widgets/category/styles/text_styles.dart';
import 'package:programacion_movil/features/presentation/widgets/category/widgets/pred_category.dart';
import 'package:programacion_movil/features/presentation/widgets/category/widgets/category_selector.dart';
import 'package:programacion_movil/features/presentation/widgets/category/widgets/create_category.dart';
import 'package:programacion_movil/features/presentation/widgets/category/widgets/selected_category.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/custom_button.dart';
import 'package:programacion_movil/features/presentation/state/game_team.dart'; // ⬅️ Agregar
import 'package:programacion_movil/data/models/category.dart'
    as models; // ⬅️ Agregar
import 'package:programacion_movil/data/repositories/category_repository.dart'; // ⬅️ Agregar
import '../home_header.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final ValueNotifier<List<String>> selectedCategories = ValueNotifier([
    "Musica",
    "Animales",
    "Paises",
    "Frutas",
    "Vegetales",
    "Colores",
  ]);

  final CategoryRepository _repository = CategoryRepository();
  int _currentIndex = 0;

  void toggleCategory(String category) {
    final current = List<String>.from(selectedCategories.value);
    current.contains(category)
        ? current.remove(category)
        : current.add(category);
    selectedCategories.value = current;
  }

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);
  }

  Future<void> _saveCategoriesToGameState() async {
    if (selectedCategories.value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes seleccionar al menos una categoría'),
        ),
      );
      return;
    }

    try {
      // Obtener todas las categorías de la BD
      final allCategoriesMap = await _repository.getAllCategories();

      // Filtrar solo las seleccionadas y convertirlas al modelo Category
      final selectedCategoryObjects = allCategoriesMap
          .where((catMap) => selectedCategories.value.contains(catMap['name']))
          .map((catMap) => models.Category.fromMap(catMap))
          .toList();

      // ⬇️ GUARDAR REFERENCIA AL GAMESTATE ANTES DE VERIFICAR MOUNTED
      if (!mounted) return;

      final gameTeam = context.read<GameTeam>();

      // Agregar las nuevas categorías
      for (final category in selectedCategoryObjects) {
        gameTeam.addCategory(category);
      }

      // ⬇️ VERIFICAR MOUNTED ANTES DE USAR CONTEXT PARA NAVEGACIÓN
      if (!mounted) return;
      context.push('/board-gamee');
    } catch (e) {
      // ⬇️ VERIFICAR MOUNTED ANTES DE MOSTRAR EL SNACKBAR
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar categorías: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: selectedCategories,
      builder: (_, selected, __) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HomeHeader(onBackPressed: () => context.pop()),

                  Text("Seleccione categorías", style: categorySubtitleStyle),
                  const SizedBox(height: 15),

                  CategorySelector(
                    currentIndex: _currentIndex,
                    onTabChanged: _onTabChanged,
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: IndexedStack(
                      index: _currentIndex,
                      children: [
                        SelectedCategory(
                          selectedCategories: selected,
                          onToggle: toggleCategory,
                        ),
                        PredCategory(
                          selectedCategories: selected,
                          onToggle: toggleCategory,
                        ),
                        CreateCategory(
                          selectedCategories: selected,
                          onToggle: toggleCategory,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  CustomButton(
                    text: "Jugar",
                    onPressed: _saveCategoriesToGameState, // ⬅️ CAMBIAR AQUÍ
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
