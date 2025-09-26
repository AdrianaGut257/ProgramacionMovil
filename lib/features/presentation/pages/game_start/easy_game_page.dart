import 'dart:async';
import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/pages/board/widgets/board_game.dart';

class EasyGamePage extends StatefulWidget {
  final List<String>? players;
  final List<String>? categories;
  /// true => modo fácil (10s) | false => modo difícil (5s)
  final bool startAsEasy;

  const EasyGamePage({
    super.key,
    this.players,
    this.categories,
    this.startAsEasy = true,
  });

  @override
  State<EasyGamePage> createState() => _EasyGamePageState();
}

class _EasyGamePageState extends State<EasyGamePage> {
  late final List<String> _players;
  late final List<String> _categories;
  late List<int> _scores;

  int _currentPlayerIndex = 0;
  int _timeLeft = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _players = (widget.players ?? const <String>[]);
    _categories = (widget.categories ?? const <String>[]);
    _scores = List<int>.filled(_players.length, 0);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = widget.startAsEasy ? 10 : 5;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_timeLeft <= 1) {
        t.cancel();
        setState(() => _timeLeft = 0);
        _onTimeUp();
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _resetTimerAndRun() {
    _timer?.cancel();
    setState(() => _timeLeft = widget.startAsEasy ? 10 : 5);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_timeLeft <= 1) {
        t.cancel();
        setState(() => _timeLeft = 0);
        _onTimeUp();
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _onCorrect() {
    if (_players.isEmpty) return;

    setState(() {
      _scores[_currentPlayerIndex] += 1;
    });

    _resetTimerAndRun();

    setState(() {
      _currentPlayerIndex =
          (_currentPlayerIndex + 1) % (_players.isEmpty ? 1 : _players.length);
    });
  }

  void _onTimeUp() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('¡Tiempo agotado!'),
        content: const Text('No se presionó ninguna letra a tiempo.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(int s) => s < 10 ? '0$s' : '$s';

  @override
  Widget build(BuildContext context) {
    final hasPlayers = _players.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // === TABLERO PRINCIPAL ===
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: BoardGame(),
              ),
            ),

            const SizedBox(height: 12),

            // === TEMPORIZADOR + CHECK ===
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.alarm, size: 28),
                const SizedBox(width: 8),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Text(
                    '00:${_fmt(_timeLeft)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: _onCorrect,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF35D3B4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.check, size: 22, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // === CONTENIDO INFERIOR (jugadores + categorías) ===
            Expanded(
              flex: 0, // 🔥 No crece infinito
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // 🔥 Evita overflow
                  children: [
                    if (hasPlayers)
                      SizedBox(
                        height: 50,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: _players.length,
                          separatorBuilder: (_, __) =>
                          const SizedBox(width: 8),
                          itemBuilder: (_, i) {
                            final isTurn = i == _currentPlayerIndex;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isTurn
                                    ? const Color(0xFF35D3B4)
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: isTurn
                                      ? const Color(0xFF35D3B4)
                                      : AppColors.primary
                                      .withValues(alpha: 0.25),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    _players[i],
                                    style: TextStyle(
                                      color: isTurn
                                          ? Colors.white
                                          : AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isTurn
                                          ? Colors.white.withValues(alpha: 0.25)
                                          : AppColors.primary
                                          .withValues(alpha: 0.10),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${_scores[i]}',
                                      style: TextStyle(
                                        color: isTurn
                                            ? Colors.white
                                            : AppColors.primary,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 8),

                    Text(
                      _categories.isEmpty
                          ? 'Sin categorías'
                          : 'Categorías: ${_categories.join(', ')}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
