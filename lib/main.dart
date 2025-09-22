import 'package:flutter/material.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'features/presentation/state/game_team.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameTeam(),
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
