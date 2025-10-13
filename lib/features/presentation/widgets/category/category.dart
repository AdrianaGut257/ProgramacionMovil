import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:programacion_movil/features/presentation/widgets/category/widgets/pred_category.dart';
import 'package:programacion_movil/features/presentation/widgets/category/widgets/category_selector.dart';
import 'package:programacion_movil/features/presentation/widgets/category/widgets/create_category.dart';
import 'package:programacion_movil/features/presentation/widgets/category/widgets/selected_category.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/custom_button.dart';
import 'package:programacion_movil/features/presentation/state/game_team.dart';
import 'package:programacion_movil/data/models/category.dart' as models;
import 'package:programacion_movil/data/repositories/category_repository.dart';
import '../home_header.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class Category extends StatefulWidget {
  final String? mode;
  final String? difficulty;
  final List<dynamic>? players;

  const Category({super.key, this.mode, this.difficulty, this.players});

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
      final allCategoriesMap = await _repository.getAllCategories();
      final selectedCategoryObjects = allCategoriesMap
          .where((catMap) => selectedCategories.value.contains(catMap['name']))
          .map((catMap) => models.Category.fromMap(catMap))
          .toList();

      if (!mounted) return;

      if (widget.mode == 'group') {
        final gameTeam = context.read<GameTeam>();
        for (final category in selectedCategoryObjects) {
          gameTeam.addCategory(category);
        }
        context.push('/board-game');
        return;
      }

      if (widget.mode == 'individual') {
        final route = widget.difficulty == 'hard'
            ? '/board-game-hard'
            : '/board-game-easy';

        context.push(
          route,
          extra: {
            'players': widget.players,
            'categories': selectedCategoryObjects,
          },
        );
      }
    } catch (e) {
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
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HomeHeader(onBackPressed: () => context.pop()),

                  Text(
                    "Seleccione categorías",
                    style: GoogleFonts.titanOne().copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      letterSpacing: 0,
                      height: 1.1,
                    ),
                  ),
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
                    onPressed: _saveCategoriesToGameState,
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
