import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RankingGame extends StatelessWidget {
  final Map<String, int> playerScores;

  const RankingGame({super.key, required this.playerScores});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen del Juego'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Puntajes finales:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: playerScores.length,
                itemBuilder: (context, index) {
                  final name = playerScores.keys.elementAt(index);
                  final score = playerScores[name] ?? 0;
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(name),
                    trailing: Text(
                      "$score pts",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text('Volver al inicio'),
                onPressed: () {
                  context.push('/');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
