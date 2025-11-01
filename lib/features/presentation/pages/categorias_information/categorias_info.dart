import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/data/datasources/app_database.dart';
import 'package:programacion_movil/features/presentation/pages/record_game/widgets/button/button_popup_delete.dart';
import 'package:programacion_movil/config/icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:programacion_movil/features/presentation/state/selected_categories.dart';

class CategoriasPage extends StatefulWidget {
  const CategoriasPage({super.key});

  @override
  State<CategoriasPage> createState() => _CategoriasPageState();
}

class _CategoriasPageState extends State<CategoriasPage> {
  List<Map<String, dynamic>> selectedCategories = [];
  bool isLoading = true;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final db = AppDatabase.instance;
    final categories = await db.getCategories();

    final filtered = categories.where((c) => c['is_default'] == 0).toList();

    setState(() {
      selectedCategories = filtered;
      isLoading = false;
    });
  }

  Future<void> _saveCategory() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre no puede estar vacío')),
      );
      return;
    }

    final db = AppDatabase.instance;
    final allCategories = await db.getCategories();
    final allNames = allCategories.map((c) => c['name'] as String).toList();

    if (allNames.contains(name)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La categoría "$name" ya existe')),
        );
      }
      return;
    }

    await db.database.then((database) async {
      await database.insert('category', {'name': name, 'is_default': 0});
    });

    _nameController.clear();
    await _loadCategories();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Categoría creada exitosamente'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _inputField() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryVariant,
        borderRadius: BorderRadius.circular(25),
        border: Border(
          bottom: BorderSide(color: AppColors.primaryVariant, width: 4),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(25),
          border: Border(
            bottom: BorderSide(color: AppColors.primaryVariant, width: 3),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  hintText: 'Escribe aquí',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(
                    Icons.category_outlined,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 9),
              child: GestureDetector(
                onTap: _saveCategory,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard(Map<String, dynamic> category, int index) {
    final String name = category['name'] as String;

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 300),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, double rotation, child) {
                          return Transform.rotate(
                            angle: rotation * 0.1,
                            child: child,
                          );
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primary.withValues(alpha: 0.8),
                                AppColors.primary,
                                AppColors.primaryVariant,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            GlobalIcons.getIcon(name),
                            color: AppColors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1F2937),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),

                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFF87171),
                          Color(0xFFEF4444),
                          Color(0xFFDC2626),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _showDeleteConfirmationDialog(category),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _deleteCategory(int id, String categoryName) async {
    final db = AppDatabase.instance;
    await db.database.then((database) async {
      await database.delete('category', where: 'id = ?', whereArgs: [id]);
    });

    if (mounted) {
      final selectedCategoriesProvider = Provider.of<SelectedCategories>(
        context,
        listen: false,
      );
      selectedCategoriesProvider.removeCategory(categoryName);
    }

    final categories = await db.getCategories();

    if (!mounted) return;

    final filtered = categories.where((c) => c['is_default'] == 0).toList();

    setState(() {
      selectedCategories = filtered;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Categoría "$categoryName" eliminada'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return ButtonPopupDelete(
          title: '¿Eliminar la categoría "${category['name']}"?',
          onCorrect: () async {
            await _deleteCategory(
              category['id'] as int,
              category['name'] as String,
            );
          },
          onReset: () {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final isSmallScreen = height < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
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
              SizedBox(height: isSmallScreen ? 8 : 16),
              Text(
                "Categorías",
                style: GoogleFonts.titanOne(
                  fontSize: width * 0.065,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: 0,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isSmallScreen ? 8 : 16),

              Text(
                'Crea tu categoría',
                style: GoogleFonts.titanOne().copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: 0,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 15),
              _inputField(),

              const SizedBox(height: 24),
              SizedBox(height: isSmallScreen ? 4 : 8),
              Text(
                "Selecciona una categoría para eliminarla",
                style: GoogleFonts.poppins(
                  fontSize: width * 0.035,
                  color: const Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : selectedCategories.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.category_outlined,
                              size: 64,
                              color: AppColors.grey.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No hay categorías creadas",
                              style: GoogleFonts.poppins(
                                color: AppColors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: selectedCategories.length,
                        itemBuilder: (context, index) {
                          final category = selectedCategories[index];
                          return _categoryCard(category, index);
                        },
                      ),
              ),
              SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
