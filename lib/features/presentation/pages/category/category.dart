import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:programacion_movil/features/presentation/pages/category/styles/button_styles.dart';
import 'package:programacion_movil/features/presentation/pages/category/styles/text_styles.dart';
import 'package:programacion_movil/features/presentation/pages/category/widgets/pred_category.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/custom_button.dart';

import 'widgets/create_category.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final ValueNotifier<List<String>> selectedCategories = ValueNotifier([
    "Música",
    "Animales",
    "Paises",
    "Frutas",
    "Vegetales",
    "Apellidos",
  ]);
  int _currentIndex = 0;

  void toggleCategory(String category) {
    final current = List<String>.from(selectedCategories.value);
    if (current.contains(category)) {
      current.remove(category);
    } else {
      current.add(category);
    }
    selectedCategories.value = current;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedCategories,
      builder: (_, selected, _) => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight), // altura extra
          child: AppBar(
            automaticallyImplyLeading: false, // control manual del leading
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Centra horizontalmente
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text('StopWords', style: categoryTitleStyle),
                ),
                const SizedBox(height: 10),
                Text("Seleccione categorias", style: categorySubtitleStyle),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                      style: categoryButtonStyle(isActive: _currentIndex == 0),
                      child: const Text('Predeterminadas'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex = 1;
                        });
                      },
                      style: categoryButtonStyle(isActive: _currentIndex == 1),
                      child: const Text('Creadas'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // IndexedStack para mostrar el contenido
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
                const SizedBox(height: 10),
                CustomButton(text: "Jugar 🎮", onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
