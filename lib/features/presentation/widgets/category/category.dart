import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/back_button_custom.dart';
import 'package:provider/provider.dart';
import 'package:programacion_movil/features/presentation/widgets/category/widgets/pred_category.dart';
import 'package:programacion_movil/features/presentation/widgets/category/widgets/category_selector.dart';
import 'package:programacion_movil/features/presentation/widgets/category/widgets/create_category.dart';
import 'package:programacion_movil/features/presentation/widgets/category/widgets/selected_category.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/custom_button.dart';
import 'package:programacion_movil/features/presentation/state/game_team.dart';
import 'package:programacion_movil/features/presentation/state/game_individual.dart';
import 'package:programacion_movil/data/models/category.dart' as models;
import 'package:programacion_movil/data/repositories/category_repository.dart';

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
        gameTeam.clearCategories();
        gameTeam.setCategories(selectedCategoryObjects);
        context.push('/board-game');
        return;
      }

      if (widget.mode == 'individual') {
        final gameIndividual = context.read<GameIndividual>();
        gameIndividual.clearCategories();
        gameIndividual.setCategories(selectedCategoryObjects);

        final route = widget.difficulty == 'hard'
            ? '/board-game-hard'
            : '/board-game-easy';

        context.push(route);
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
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final isSmallScreen = height < 700;

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
                      Row(
                        children: [
                          BackButtonCustom(onPressed: () => context.pop()),
                          const Spacer(),
                        ],
                      ),
                      SizedBox(height: 2),
                     Center(
                          child: FractionallySizedBox(
                            widthFactor: 0.9, 
                            child: AspectRatio(
                              aspectRatio: 370 / 170, 
                              child: Image.asset(
                                'assets/icons/logo.png',
                                fit: BoxFit.contain, 
                              ),
                            ),
                          ),
                        ),

                      SizedBox(height: isSmallScreen ? 5 : 10),

                  Text(
                    "Seleccione categorías",
                    style: GoogleFonts.titanOne().copyWith(
                      fontSize: isSmallScreen ? 24 : 30,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      letterSpacing: 0,
                      height: 1.1,
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 10 : 15),

                  CategorySelector(
                    currentIndex: _currentIndex,
                    onTabChanged: _onTabChanged,
                  ),

                  SizedBox(height: isSmallScreen ? 15 : 20),

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

                  SizedBox(height: isSmallScreen ? 5 : 10),

                  CustomButton(
                    text: "Jugar",
                    onPressed: _saveCategoriesToGameState,
                  ),

                  SizedBox(height: isSmallScreen ? 5 : 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
