import 'dart:math';
import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class TutorialGameScreen extends StatefulWidget {
  const TutorialGameScreen({super.key});

  @override
  State<TutorialGameScreen> createState() => _TutorialGameScreenState();
}

class _TutorialGameScreenState extends State<TutorialGameScreen> {
  int _currentStep = 0;
  final GlobalKey _playerNameKey = GlobalKey();
  final GlobalKey _chronometerKey = GlobalKey();
  final GlobalKey _categoryKey = GlobalKey();
  final GlobalKey _boardKey = GlobalKey();
  final GlobalKey _letterKey = GlobalKey();
  final GlobalKey _nextButtonKey = GlobalKey();
  final GlobalKey _endGameButtonKey = GlobalKey();

  final List<TutorialStep> _steps = [
    TutorialStep(
      title: 'Paso 1: Nombre del jugador',
      description: 'Aquí verás el nombre del jugador actual y su puntaje',
      highlightKey: 'playerName',
      playerName: 'juan',
      playerScore: 0,
      categoryName: 'ANIMALES',
      chronometerTime: '00:10',
      letters: ['D', 'X', 'B', 'Ñ', 'K', 'I'],
      selectedLetterIndex: -1,
    ),
    TutorialStep(
      title: 'Paso 2: Cronómetro',
      description: 'El cronómetro cuenta el tiempo que tienes para responder',
      highlightKey: 'chronometer',
      playerName: 'juan',
      playerScore: 0,
      categoryName: 'ANIMALES',
      chronometerTime: '00:10',
      letters: ['D', 'X', 'B', 'Ñ', 'K', 'I'],
      selectedLetterIndex: -1,
    ),
    TutorialStep(
      title: 'Paso 3: Categoría',
      description: 'Esta es la categoría actual del juego',
      highlightKey: 'category',
      playerName: 'juan',
      playerScore: 0,
      categoryName: 'ANIMALES',
      chronometerTime: '00:10',
      letters: ['D', 'X', 'B', 'Ñ', 'K', 'I'],
      selectedLetterIndex: -1,
    ),
    TutorialStep(
      title: 'Paso 4: Tablero de letras',
      description: 'Selecciona una letra del círculo para comenzar',
      highlightKey: 'board',
      playerName: 'juan',
      playerScore: 0,
      categoryName: 'ANIMALES',
      chronometerTime: '00:10',
      letters: ['D', 'X', 'B', 'Ñ', 'K', 'I'],
      selectedLetterIndex: -1,
    ),
    TutorialStep(
      title: 'Paso 5: Seleccionar letra',
      description: 'Toca una letra para seleccionarla',
      highlightKey: 'letter',
      playerName: 'juan',
      playerScore: 0,
      categoryName: 'ANIMALES',
      chronometerTime: '00:08',
      letters: ['D', 'X', 'B', 'Ñ', 'K', 'I'],
      selectedLetterIndex: 0,
    ),
    TutorialStep(
      title: 'Paso 6: Letra seleccionada',
      description:
          '¡La letra cambia! Ahora debes decir una palabra que empiece con "D" de la categoría "ANIMALES"',
      highlightKey: 'letter',
      playerName: 'juan',
      playerScore: 5,
      categoryName: 'ANIMALES',
      chronometerTime: '00:06',
      letters: ['D', 'X', 'B', 'Ñ', 'K', 'I'],
      selectedLetterIndex: 0,
    ),
    TutorialStep(
      title: 'Paso 7: Botón Siguiente',
      description: 'Presiona este botón para pasar a la siguiente categoría',
      highlightKey: 'nextButton',
      playerName: 'juan',
      playerScore: 10,
      categoryName: 'ANIMALES',
      chronometerTime: '00:05',
      letters: ['D', 'X', 'B', 'Ñ', 'K', 'I'],
      selectedLetterIndex: -1,
    ),
    TutorialStep(
      title: 'Paso 8: Terminar juego',
      description:
          'Presiona este botón rojo para terminar el juego completamente',
      highlightKey: 'endGameButton',
      playerName: 'juan',
      playerScore: 10,
      categoryName: 'ANIMALES',
      chronometerTime: '00:05',
      letters: ['D', 'X', 'B', 'Ñ', 'K', 'I'],
      selectedLetterIndex: -1,
    ),
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final currentStepData = _steps[_currentStep];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Tutorial',
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: _nextStep,
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 160),

                    // Categoría y Cronómetro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            key: _categoryKey,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.category_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    currentStepData.categoryName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          key: _chronometerKey,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.timer,
                                color: Colors.black87,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                currentStepData.chronometerTime,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Nombre del jugador compacto
                    Container(
                      key: _playerNameKey,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4DD0E1),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF4DD0E1,
                            ).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        '${currentStepData.playerName}  ${currentStepData.playerScore}',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(
                      height: 290,
                      child: Center(child: _buildBoard(currentStepData)),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            key: _nextButtonKey,
                            onPressed: () {},
                            icon: const Icon(
                              Icons.skip_next,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: const Text(
                              "Siguiente",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            key: _endGameButtonKey,
                            onPressed: () {},
                            icon: const Icon(
                              Icons.stop_circle,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: const Text(
                              "Terminar juego",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (currentStepData.highlightKey != 'none')
              _buildHighlightOverlay(currentStepData),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildInstructionBanner(currentStepData),
            ),

            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: _buildNavigationBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoard(TutorialStep step) {
    final double radius = 90;
    final letters = step.letters;

    return Container(
      key: _boardKey,
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 280,
            height: 280,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          for (int i = 0; i < letters.length; i++)
            Transform.translate(
              offset: Offset(
                radius * cos(2 * pi * i / letters.length - pi / 2),
                radius * sin(2 * pi * i / letters.length - pi / 2),
              ),
              child: Container(
                key: i == step.selectedLetterIndex ? _letterKey : null,
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: i == step.selectedLetterIndex
                        ? [const Color(0xFF10B981), const Color(0xFF059669)]
                        : [const Color(0xFF4DD0E1), const Color(0xFF26C6DA)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: i == step.selectedLetterIndex
                          ? const Color(0xFF10B981).withValues(alpha: 0.4)
                          : Colors.black.withValues(alpha: 0.1),
                      blurRadius: i == step.selectedLetterIndex ? 12 : 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    letters[i],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CircleAvatar(radius: 16, backgroundColor: Colors.yellow),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionBanner(TutorialStep step) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.secondaryVariant],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.secondary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step.title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentStep + 1}/${_steps.length}',
                  style: GoogleFonts.poppins(
                    color: AppColors.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.secondary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    step.description,
                    style: GoogleFonts.poppins(
                      color: AppColors.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightOverlay(TutorialStep step) {
    return IgnorePointer(
      child: CustomPaint(
        painter: SpotlightPainter(
          highlightKey: step.highlightKey,
          playerNameKey: _playerNameKey,
          chronometerKey: _chronometerKey,
          categoryKey: _categoryKey,
          boardKey: _boardKey,
          letterKey: _letterKey,
          nextButtonKey: _nextButtonKey,
          endGameButtonKey: _endGameButtonKey,
        ),
        child: Container(),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            ElevatedButton.icon(
              onPressed: _previousStep,
              icon: const Icon(Icons.arrow_back, size: 20),
              label: const Text('Atrás'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.grey,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            )
          else
            const SizedBox(width: 90),
          Row(
            children: List.generate(_steps.length > 3 ? 3 : _steps.length, (
              index,
            ) {
              int displayStep;
              if (_steps.length <= 3) {
                displayStep = index;
              } else if (_currentStep == 0) {
                displayStep = index;
              } else if (_currentStep == _steps.length - 1) {
                displayStep = _steps.length - 3 + index;
              } else {
                displayStep = _currentStep - 1 + index;
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: displayStep == _currentStep ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: displayStep == _currentStep
                      ? AppColors.primary
                      : AppColors.grey,
                ),
              );
            }),
          ),
          ElevatedButton.icon(
            onPressed: _nextStep,
            label: Text(
              _currentStep == _steps.length - 1 ? 'Finalizar' : 'Siguiente',
            ),
            icon: Icon(
              _currentStep == _steps.length - 1
                  ? Icons.check_circle
                  : Icons.arrow_forward,
              size: 20,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialStep {
  final String title;
  final String description;
  final String highlightKey;
  final String playerName;
  final int playerScore;
  final String categoryName;
  final String chronometerTime;
  final List<String> letters;
  final int selectedLetterIndex;

  TutorialStep({
    required this.title,
    required this.description,
    required this.highlightKey,
    required this.playerName,
    required this.playerScore,
    required this.categoryName,
    required this.chronometerTime,
    required this.letters,
    required this.selectedLetterIndex,
  });
}

class SpotlightPainter extends CustomPainter {
  final String highlightKey;
  final GlobalKey playerNameKey;
  final GlobalKey chronometerKey;
  final GlobalKey categoryKey;
  final GlobalKey boardKey;
  final GlobalKey letterKey;
  final GlobalKey nextButtonKey;
  final GlobalKey endGameButtonKey;

  SpotlightPainter({
    required this.highlightKey,
    required this.playerNameKey,
    required this.chronometerKey,
    required this.categoryKey,
    required this.boardKey,
    required this.letterKey,
    required this.nextButtonKey,
    required this.endGameButtonKey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    RRect? highlightRect;

    switch (highlightKey) {
      case 'playerName':
        highlightRect = _getHighlightRect(playerNameKey, padding: 8);
        break;
      case 'chronometer':
        highlightRect = _getHighlightRect(chronometerKey, padding: 8);
        break;
      case 'category':
        highlightRect = _getHighlightRect(categoryKey, padding: 8);
        break;
      case 'board':
        highlightRect = _getHighlightRect(boardKey, padding: 16);
        break;
      case 'letter':
        highlightRect = _getHighlightRect(
          letterKey,
          padding: 8,
          isCircle: true,
        );
        break;
      case 'nextButton':
        highlightRect = _getHighlightRect(nextButtonKey, padding: 8);
        break;
      case 'endGameButton':
        highlightRect = _getHighlightRect(endGameButtonKey, padding: 8);
        break;
    }

    if (highlightRect != null) {
      final path = Path()
        ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
        ..addRRect(highlightRect)
        ..fillType = PathFillType.evenOdd;
      final darkOverlay = Paint()
        ..color = const Color(0x99000000)
        ..style = PaintingStyle.fill;

      canvas.drawPath(path, darkOverlay);

      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawRRect(highlightRect, borderPaint);

      final innerBorderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawRRect(highlightRect, innerBorderPaint);
    }
  }

  RRect? _getHighlightRect(
    GlobalKey key, {
    double padding = 8,
    bool isCircle = false,
  }) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return null;

    try {
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;

      if (isCircle) {
        final centerX = position.dx + size.width / 2;
        final centerY = position.dy + size.height / 2 - 90;
        final radius = (size.width / 2) + padding;

        return RRect.fromRectAndRadius(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          Radius.circular(radius),
        );
      }

      return RRect.fromRectAndRadius(
        Rect.fromLTWH(
          position.dx - padding,
          position.dy - padding - 90,
          size.width + (padding * 2),
          size.height + (padding * 2),
        ),
        const Radius.circular(25),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
