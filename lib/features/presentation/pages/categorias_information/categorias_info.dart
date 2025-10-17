import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/data/datasources/app_database.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board_information/button_popup.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/add_remove_button.dart';
import 'package:programacion_movil/config/icons.dart';
import '../../widgets/home_header.dart';

class CategoriasPage extends StatefulWidget {
  const CategoriasPage({super.key});

  @override
  State<CategoriasPage> createState() => _CategoriasPageState();
}

  class _CategoriasPageState extends State<CategoriasPage> {
  List<Map<String, dynamic>> selectedCategories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
  final db = AppDatabase.instance;
  final categories = await db.getCategories();

  // Filtrar solo las categorías personalizadas
  final filtered = categories.where((c) => c['is_default'] == 0).toList();

  setState(() {
    selectedCategories = filtered;
    isLoading = false;
  });

    //print("estas son las categorias: $categories");
  }

  Widget _categoryCard(Map<String, dynamic> category) {
  final String name = category['name'] as String;

  return Container(
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              GlobalIcons.getIcon(name),
              color: AppColors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                name,
                style: const TextStyle(color: AppColors.white, fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 28),
            AddRemoveButton(
              isAdd: false,
              onPressed: () => _showDeleteConfirmationDialog(category),
            ),
          ],
        ),
      ),
    ),
  );
}

Future _deleteCategory(int id) async {
  final db = AppDatabase.instance;
  await db.database.then((database) async {
    await database.delete(
      'category',
      where: 'id = ?',
      whereArgs: [id],
    );
  });

  // Vuelve a obtener las categorías actualizadas
  final categories = await db.getCategories();

  if (!mounted) return;

  // Filtra solo las que son personalizadas
  final filtered = categories.where((c) => c['is_default'] == 0).toList();

  setState(() {
    selectedCategories = filtered;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Categoría eliminada'),
      duration: Duration(seconds: 2),
    ),
  );
}

void _showDeleteConfirmationDialog(Map<String, dynamic> category) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return ButtonPopup(
        title: '¿Eliminar la categoría "${category['name']}"?',
        onCorrect: () async {
          await _deleteCategory(category['id'] as int);
        },
        onReset: () {
          // No hacer nada, ButtonPopup lo cierra
        },
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
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              HomeHeader(),
              SizedBox(height: isSmallScreen ? 8 : 16),
              Text(
                "Categorías",
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isSmallScreen ? 4 : 8),
              Text(
                "Selecciona una categoría para eliminarla",
                style: TextStyle(
                  fontSize: width * 0.035,
                  color: const Color.fromARGB(96, 0, 0, 0),
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Expanded(
                child: selectedCategories.isEmpty
                    ? Center(
                        child: Text(
                          "No hay categorías seleccionadas",
                          style: TextStyle(color: AppColors.grey, fontSize: 20),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: selectedCategories.length,
                        itemBuilder: (context, index) {
                        final category = selectedCategories[index];
                        return _categoryCard(category);
                        },
                      ),
              ),
              SizedBox(height: height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
