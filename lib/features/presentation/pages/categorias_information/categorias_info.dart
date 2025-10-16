import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    setState(() {
      selectedCategories = categories;
      isLoading = false;
    });
  }

  Widget _categoryCard(Map<String, dynamic> category) {
  final String name = category['name'] as String;
  final int id = category['id'] as int;

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

void _onRemoveCategory(String category) async {
    // Aquí borras en la db y también en la lista local para refrescar la UI
    await AppDatabase.instance.deleteCategory(category); // agrega este método en tu DB helper si no existe
    setState(() {
      selectedCategories.remove(category);
    });
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

  final categories = await db.getCategories();

  setState(() {
    selectedCategories = categories;
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

          // Espera hasta que termine el frame actual antes de cerrar el diálogo
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Navigator.canPop(dialogContext)) {
              Navigator.pop(dialogContext);
            }
          });
        },
        onReset: () {
          if (Navigator.canPop(dialogContext)) {
            Navigator.pop(dialogContext);
          }
        },
      );
    },
  );
}




Future<List<Map<String, dynamic>>> _fetchCategories() async {
  final db = AppDatabase.instance;
  final categories = await db.getCategories();
  return categories;
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
              HomeHeader(onBackPressed: () => context.pop()),
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
                "Selecciona una categoría para comenzar a jugar.",
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
