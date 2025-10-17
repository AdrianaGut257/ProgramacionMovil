import 'package:flutter/material.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'features/presentation/state/game_team.dart';
import 'features/presentation/state/game_individual.dart';
import 'features/presentation/utils/sound_manager.dart'; // 🔹 Importar SoundManager
import 'package:provider/provider.dart';

Future<void> main() async { // 🔹 Agregar async
  WidgetsFlutterBinding.ensureInitialized(); // 🔹 Requerido para inicializar antes de runApp
  
  // 🔹 Inicializar sistema de sonidos
  await SoundManager.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameTeam()),
        ChangeNotifierProvider(create: (_) => GameIndividual()),
      ],
      child: const StopWordsApp(),
    ),
  );
}

class StopWordsApp extends StatelessWidget {
  const StopWordsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'StopWords',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}