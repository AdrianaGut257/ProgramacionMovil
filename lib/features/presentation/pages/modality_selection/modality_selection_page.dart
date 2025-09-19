import 'package:flutter/material.dart';

class ModalitySelectionPage extends StatefulWidget {
  const ModalitySelectionPage({super.key});

  @override
  State<ModalitySelectionPage> createState() => _ModalitySelectionPageState();
}

class _ModalitySelectionPageState extends State<ModalitySelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar Modalidad')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/player-register');
              },
              child: const Text('Modo Individual'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/group-mode');
              },
              child: const Text('Modo Grupal'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/group-mode');
              },
              child: const Text('Modo Grupal'),
            ),
          ],
        ),
      ),
    );
  }
}
