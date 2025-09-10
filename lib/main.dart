import 'package:flutter/material.dart';
import 'config/router.dart';
import 'config/theme.dart';

void main() {
  runApp(const StopWordsApp());
}

class StopWordsApp extends StatelessWidget {
  const StopWordsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'StopWords',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
