import 'package:flutter/material.dart';
//import '../../../../config/colors.dart';
import '../../widgets/buttons/custom_button.dart';

class SelectCategoriesPage extends StatefulWidget {
  final List<String> players;
  const SelectCategoriesPage({super.key, required this.players});

  @override
  State<SelectCategoriesPage> createState() => _SelectCategoriesPageState();
}

class _SelectCategoriesPageState extends State<SelectCategoriesPage> {
  final List<String> categories = ['Animales', 'Frutas', 'Países', 'Deportes'];
  final List<String> selectedCategories = [];

  void _toggleCategory(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  void _continue() {
    debugPrint('Jugadores: ${widget.players}');
    debugPrint('Categorías seleccionadas: $selectedCategories');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar Categorías')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Selecciona categorías:'),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: categories.map((c) {
                  return CheckboxListTile(
                    title: Text(c),
                    value: selectedCategories.contains(c),
                    onChanged: (_) => _toggleCategory(c),
                  );
                }).toList(),
              ),
            ),
            CustomButton(text: 'Continuar', onPressed: _continue),
          ],
        ),
      ),
    );
  }
}
