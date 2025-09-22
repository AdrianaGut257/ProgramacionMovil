//import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:programacion_movil/features/presentation/pages/category/styles/button_styles.dart';
import 'package:programacion_movil/features/presentation/pages/category/styles/text_styles.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/custom_button.dart';

import 'widgets/create_category.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final List<String> selectedCategories = [];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(20),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
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
                    const Center(child: Text("Categorias Predeterminadas")),
                    CreateCategory(
                      onCategoryCreated: (String categoryName) {
                        setState(() {
                          selectedCategories.add(categoryName);
                        });
                      },
                      onSelectionChanged: (List<String> selected) {
                        // ✅ Recibe cambios
                        setState(() {
                          selectedCategories.clear();
                          selectedCategories.addAll(selected);
                        });
                      },
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
    );
  }
}
