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
import 'package:programacion_movil/features/presentation/state/selected_categories.dart';
import 'package:programacion_movil/data/models/category.dart' as models;
import 'package:programacion_movil/data/repositories/category_repository.dart';
import 'package:programacion_movil/features/presentation/widgets/modals/validation_dialog.dart';

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
  final CategoryRepository _repository = CategoryRepository();
  int _currentIndex = 0;
  Key _createCategoryKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _syncCategories();
  }

  void _onTabChanged(int index) {
    setState(() {
      if (index == 2 && _currentIndex != 2) {
        _createCategoryKey = UniqueKey();
      }
      _currentIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncCategories();
    if (_currentIndex == 2) {
      setState(() {
        _createCategoryKey = UniqueKey();
      });
    }
  }

  Future<void> _syncCategories() async {
    try {
      final selectedCategoriesProvider = Provider.of<SelectedCategories>(
        context,
        listen: false,
      );

      final allCategoriesMap = await _repository.getAllCategories();
      final dbCategoryNames = allCategoriesMap
          .map((catMap) => catMap['name'] as String)
          .toSet();

      final selectedCategories = selectedCategoriesProvider.categories;

      final categoriesToRemove = selectedCategories
          .where((category) => !dbCategoryNames.contains(category))
          .toList();

      for (final category in categoriesToRemove) {
        selectedCategoriesProvider.removeCategory(category);
      }
    } catch (e) {
      debugPrint('Error sincronizando categorías: $e');
    }
  }

  Future<void> _saveCategoriesToGameState() async {
    final selectedCategoriesProvider = Provider.of<SelectedCategories>(
      context,
      listen: false,
    );
    final selectedCategoryNames = selectedCategoriesProvider.categories;

    if (selectedCategoryNames.isEmpty) {
      ValidationDialog.show(
        context,
        "Seleccione categorías predeterminadas o creadas para continuar",
        ValidationType.noCategories,
      );
      return;
    }

    try {
      final allCategoriesMap = await _repository.getAllCategories();
      final selectedCategoryObjects = allCategoriesMap
          .where((catMap) => selectedCategoryNames.contains(catMap['name']))
          .map((catMap) => models.Category.fromMap(catMap))
          .toList();

      if (!mounted) return;

      if (widget.mode == 'group') {
        final gameTeam = Provider.of<GameTeam>(context, listen: false);
        gameTeam.clearCategories();
        gameTeam.setCategories(selectedCategoryObjects);
        context.push('/board-game');
        return;
      }

      if (widget.mode == 'individual') {
        final gameIndividual = Provider.of<GameIndividual>(
          context,
          listen: false,
        );
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

    return Consumer<SelectedCategories>(
      builder: (context, selectedCategoriesProvider, child) {
        final selected = selectedCategoriesProvider.categories;

        return Scaffold(
          backgroundColor: AppColors.white,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                          const SizedBox(height: 2),
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

                          SizedBox(
                            height: 400,
                            child: IndexedStack(
                              index: _currentIndex,
                              children: [
                                SelectedCategory(
                                  selectedCategories: selected,
                                  onToggle:
                                      selectedCategoriesProvider.toggleCategory,
                                ),
                                PredCategory(
                                  selectedCategories: selected,
                                  onToggle:
                                      selectedCategoriesProvider.toggleCategory,
                                ),
                                CreateCategory(
                                  key: _createCategoryKey,
                                  selectedCategories: selected,
                                  onToggle:
                                      selectedCategoriesProvider.toggleCategory,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    isSmallScreen ? 5 : 10,
                    20,
                    isSmallScreen ? 5 : 10,
                  ),
                  child: CustomButton(
                    text: "Jugar",
                    onPressed: _saveCategoriesToGameState,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
