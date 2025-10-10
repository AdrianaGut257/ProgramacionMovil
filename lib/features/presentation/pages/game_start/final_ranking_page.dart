import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:programacion_movil/config/colors.dart';

class FinalRankingPage extends StatelessWidget {
  final List<String> players;
  final List<int> scores;

  const FinalRankingPage({
    super.key,
    required this.players,
    required this.scores,
  });

  @override
  Widget build(BuildContext context) {
    // Emparejar y ordenar por puntaje desc
    final entries = <_Entry>[];
    for (int i = 0; i < players.length; i++) {
      entries.add(_Entry(name: players[i], score: i < scores.length ? scores[i] : 0));
    }
    entries.sort((a, b) => b.score.compareTo(a.score));

    // Top 3 (si hay)
    final top1 = entries.isNotEmpty ? entries[0] : null;
    final top2 = entries.length > 1 ? entries[1] : null;
    final top3 = entries.length > 2 ? entries[2] : null;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Título
              Text(
                'StopWords',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'RANKING FINAL',
                style: TextStyle(
                  color: Color(0xFF7A54FF),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 24),

              // Podio
              _Podium(top1: top1, top2: top2, top3: top3),

              const SizedBox(height: 24),

              // Lista ordenada
              ...List.generate(entries.length, (i) {
                final e = entries[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.06),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        // posición
                        Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            e.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          '${e.score}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Botón volver a inicio
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF31D4C0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Volver a inicio'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Podium extends StatelessWidget {
  final _Entry? top1;
  final _Entry? top2;
  final _Entry? top3;

  const _Podium({required this.top1, required this.top2, required this.top3});

  @override
  Widget build(BuildContext context) {
    // Alturas relativas como en el mock
    const h1 = 140.0; // 1er lugar
    const h2 = 110.0; // 2do
    const h3 = 100.0; // 3ro

    Widget _col(_Entry? e, double height, String place) {
      final purple = const Color(0xFF7A54FF);
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (e != null) _BubbleScore(score: e.score),
          const SizedBox(height: 6),
          Container(
            width: 80,
            height: height,
            decoration: BoxDecoration(
              color: purple,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              place,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 28,
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 90,
            child: Text(
              e?.name ?? '-',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _col(top2, h2, '2'),
        _col(top1, h1, '1'),
        _col(top3, h3, '3'),
      ],
    );
  }
}

class _BubbleScore extends StatelessWidget {
  final int score;
  const _BubbleScore({required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFB84D),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Text(
        '$score',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _Entry {
  final String name;
  final int score;
  _Entry({required this.name, required this.score});
}
