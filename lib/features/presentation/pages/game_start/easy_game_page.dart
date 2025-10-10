import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/pages/game_start/widgets/letter_board.dart';

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
  int _currentCategoryIndex = 0;

  int _timeLeft = 10;
  Timer? _timer;

  // 🚫 Bandera para saber si ya finalizamos (no mostrar diálogos ni ticks)
  bool _gameEnded = false;

  @override
  void initState() {
    super.initState();
    _players = widget.players ?? const <String>[];
    _categories = widget.categories ?? const <String>[];
    _scores = List<int>.filled(_players.length, 0);
    _startTimer();
  }

  // ===== Helpers =====
  String _fmt(int s) => s < 10 ? '0$s' : '$s';
  String get _currentPlayer =>
      _players.isNotEmpty ? _players[_currentPlayerIndex] : 'Jugador';
  String get _currentCategory =>
      _categories.isNotEmpty ? _categories[_currentCategoryIndex] : 'Categoría';

  // ===== Timer =====
  void _startTimer() {
    _timer?.cancel();
    _timeLeft = widget.startAsEasy ? 10 : 5;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted || _gameEnded) {
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

  void _pauseTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _resumeTimer() {
    if (_timer != null || _gameEnded) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted || _gameEnded) {
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
    _pauseTimer();
    setState(() => _timeLeft = widget.startAsEasy ? 10 : 5);
    _resumeTimer();
  }

  // ===== Lógica de juego =====
  void _onCorrect() {
    if (_players.isEmpty || _gameEnded) return;
    setState(() {
      _scores[_currentPlayerIndex] += 1;
      _currentPlayerIndex =
          (_currentPlayerIndex + 1) % (_players.isEmpty ? 1 : _players.length);
    });
    _resetTimerAndRun();
  }

  void _onTimeUp() {
    // ⛑️ Si ya terminamos o esta ruta no es la actual, NO hacer nada
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    if (_gameEnded || !mounted || !isCurrent) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('¡Tiempo agotado!'),
        content: const Text('No se validó ninguna respuesta a tiempo.'),
        actions: [
          TextButton(
            onPressed: () {
              if (mounted) Navigator.of(context).pop();
              if (mounted) Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showNextCategoryDialog(String category) async {
    if (_gameEnded) return;
    _pauseTimer();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // icono
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEFF0FF),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.category, color: Color(0xFF5B4BC4), size: 32),
              ),
              const SizedBox(height: 12),
              const Text(
                '¡Nueva Categoría!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  category.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .3,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Prepárate',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF31D4C0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text(
                    '¡Comenzar!',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    _resetTimerAndRun();
  }

  void _goNextCategory() {
    if (_categories.isEmpty || _gameEnded) return;
    setState(() {
      _currentCategoryIndex =
          (_currentCategoryIndex + 1) % _categories.length; // loop
    });
    _showNextCategoryDialog(_currentCategory);
  }

  // 🚪 Terminar juego: cancela timer, marca fin y navega al ranking
  void _endGame() {
    _gameEnded = true;
    _pauseTimer();
    context.go('/final-ranking', extra: {
      'players': _players,
      'scores' : _scores,
    }); // go() reemplaza la ruta actual → no queda el timer atrás
  }

  @override
  void dispose() {
    _gameEnded = true;
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasPlayers = _players.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            children: [
              // === Categoría arriba ===
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.category, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      _currentCategory.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // === Jugador en turno (chip morado con puntaje) ===
              if (hasPlayers)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currentPlayer,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${_scores.isNotEmpty ? _scores[_currentPlayerIndex] : 0}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // === Temporizador ===
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.alarm, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '00:${_fmt(_timeLeft)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Selecciona una letra',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              // === Tablero ===
              Expanded(
                child: Center(
                  child: LetterBoard(
                    size: 340,
                    onOpenDialog: _pauseTimer,
                    onCloseDialog: (ok) {
                      if (_gameEnded) return;
                      if (ok == true) {
                        // onValid llamará a _onCorrect y ya reinicia
                      } else {
                        _resumeTimer(); // ✖ o dismiss -> continuar
                      }
                    },
                    onValid: _onCorrect,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // === BOTONES ABAJO ===
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 4),
                child: Column(
                  children: [
                    // Siguiente categoría (morado)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onPressed: _categories.isEmpty ? null : _goNextCategory,
                        icon: const Icon(Icons.fast_forward),
                        label: const Text('Siguiente categoría'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Terminar juego (rojo) → Ranking final (timer detenido)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE64A64),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onPressed: _endGame,
                        icon: const Icon(Icons.stop_circle_outlined),
                        label: const Text('Terminar juego'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
