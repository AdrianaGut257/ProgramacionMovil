import 'package:flutter/material.dart';
import 'screens/stopwords_winners_screen.dart';

class RankingGame extends StatelessWidget {
  final Map<String, int> playerScores;

  const RankingGame({super.key, required this.playerScores});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StopWordsWinnersScreen(playerScores: playerScores),
    );
  }
}
