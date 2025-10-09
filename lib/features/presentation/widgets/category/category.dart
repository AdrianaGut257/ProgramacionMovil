import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:programacion_movil/features/presentation/widgets/category/styles/text_styles.dart';
import 'package:programacion_movil/features/presentation/widgets/category/widgets/pred_category.dart';
import 'package:programacion_movil/features/presentation/widgets/category/widgets/category_selector.dart';
import 'package:programacion_movil/features/presentation/widgets/category/widgets/create_category.dart';
import 'package:programacion_movil/features/presentation/widgets/category/widgets/selected_category.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/custom_button.dart';
import '../home_header.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final ValueNotifier<List<String>> selectedCategories = ValueNotifier([
    "Música",
    "Animales",
    "Países",
    "Frutas",
    "Vegetales",
    "Apellidos",
  ]);

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
                    onPressed: () => context.push('/board-gamee'),
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
