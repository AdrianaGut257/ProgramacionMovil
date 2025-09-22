import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:programacion_movil/features/presentation/pages/category/styles/text_styles.dart';
import 'package:programacion_movil/features/presentation/pages/category/widgets/pred_category.dart';
import 'package:programacion_movil/features/presentation/pages/category/widgets/category_selector.dart';
import 'package:programacion_movil/features/presentation/pages/category/widgets/create_category.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/custom_button.dart';
import '../../widgets/home_header.dart';

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

  void _onModeChanged(bool isPred) {
    setState(() => _currentIndex = isPred ? 0 : 1);
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
                  const HomeHeader(),

                  Text("Seleccione categorías", style: categorySubtitleStyle),
                  const SizedBox(height: 15),

                  CategorySelector(
                    isPredSelected: _currentIndex == 0,
                    onModeChanged: _onModeChanged,
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: IndexedStack(
                      index: _currentIndex,
                      children: [
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
                    icon: Icons.play_arrow_rounded,
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
