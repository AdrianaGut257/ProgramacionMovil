import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:programacion_movil/features/presentation/pages/category/widgets/create_category.dart';
import '../../../../config/colors.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final List<String> selectedCategories = [];
  int _currentIndex = 1; // 0=Predeterminadas, 1=Creadas

  @override
  Widget build(BuildContext context) {
    final args = GoRouterState.of(context).extra as Map?;
    final players = (args?['players'] as List?)?.cast<String>() ?? <String>[];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('StopWords'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Seleccione categorías",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),

              // Tabs: Predeterminadas / Creadas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _TabButton(
                    text: 'Predeterminadas',
                    active: _currentIndex == 0,
                    onTap: () => setState(() => _currentIndex = 0),
                  ),
                  _TabButton(
                    text: 'Creadas',
                    active: _currentIndex == 1,
                    onTap: () => setState(() => _currentIndex = 1),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Contenido por pestaña
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: [
                    const Center(child: Text("Categorías Predeterminadas")),
                    CreateCategory(
                      onCategoryCreated: (String categoryName) {
                        setState(() {
                          if (!selectedCategories.contains(categoryName)) {
                            selectedCategories.add(categoryName);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Botón Jugar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Jugar 🎮",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    if (players.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Faltan jugadores')),
                      );
                      return;
                    }
                    if (selectedCategories.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Selecciona al menos una categoría'),
                        ),
                      );
                      return;
                    }

                    context.push('/play-easy', extra: {
                      'players': players,
                      'categories': selectedCategories,
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _TabButton({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.25),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: active ? Colors.white : AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
