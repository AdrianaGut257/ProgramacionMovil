import 'package:flutter/material.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'features/presentation/state/game_team.dart';
import 'features/presentation/state/game_individual.dart';
import 'features/presentation/utils/sound_manager.dart';
import 'features/presentation/state/selected_categories.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SoundManager.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameTeam()),
        ChangeNotifierProvider(create: (_) => GameIndividual()),
        ChangeNotifierProvider(create: (_) => SelectedCategories()),
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
