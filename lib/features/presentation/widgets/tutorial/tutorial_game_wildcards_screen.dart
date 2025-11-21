import 'dart:math';
import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class TutorialGameWildcardsScreen extends StatefulWidget {
  const TutorialGameWildcardsScreen({super.key});

  @override
  State<TutorialGameWildcardsScreen> createState() =>
      _TutorialGameWildcardsScreenState();
}

class _TutorialGameWildcardsScreenState
    extends State<TutorialGameWildcardsScreen> {
  int _currentStep = 0;
  final GlobalKey _wildcardLetterKey = GlobalKey();
  final GlobalKey _selectedLetterKey = GlobalKey();

  final List<TutorialStep> _steps = [
    TutorialStep(
      title: 'Comodín 1: +5 Segundos',
      description:
          'Este comodín te otorga 5 segundos adicionales en el cronómetro',
      highlightKey: 'wildcardLetter',
      playerName: 'Juan',
      playerScore: 0,
      categoryName: 'ANIMALES',
      chronometerTime: '00:10',
      letters: ['D', 'X', 'B', 'Ñ', 'K', 'I'],
      wildcardIndex: 0,
      wildcardIcon: Icons.timer,
      wildcardColor: Colors.green,
      blockedIndices: [],
      selectedIndex: -1,
      showBlockedLetters: false,
    ),
    TutorialStep(
      title: 'Comodín 2: Saltar Turno',
      description: 'Obtén 5 puntos automáticamente y pasa al siguiente jugador',
      highlightKey: 'wildcardLetter',
      playerName: 'Juan',
      playerScore: 5,
      categoryName: 'ANIMALES',
      chronometerTime: '00:09',
      letters: ['A', 'X', 'B', 'Ñ', 'K', 'I'],
      wildcardIndex: 2,
      wildcardIcon: Icons.skip_next,
      wildcardColor: Colors.blue,
      blockedIndices: [],
      selectedIndex: -1,
      showBlockedLetters: false,
    ),
    TutorialStep(
      title: 'Comodín 3: Doble Puntos',
      description:
          'Duplica la puntuación que obtengas con tu respuesta correcta',
      highlightKey: 'wildcardLetter',
      playerName: 'Juan',
      playerScore: 10,
      categoryName: 'ANIMALES',
      chronometerTime: '00:08',
      letters: ['A', 'X', 'S', 'Ñ', 'K', 'I'],
      wildcardIndex: 4,
      wildcardIcon: Icons.star,
      wildcardColor: Colors.amber,
      blockedIndices: [],
      selectedIndex: -1,
      showBlockedLetters: false,
    ),
    TutorialStep(
      title: 'Comodín 4: Bloquear Letras',
      description:
          'Al tocar este comodín, podrás elegir una letra disponible para el siguiente jugador',
      highlightKey: 'wildcardLetter',
      playerName: 'Juan',
      playerScore: 15,
      categoryName: 'ANIMALES',
      chronometerTime: '00:07',
      letters: ['A', 'X', 'S', 'Ñ', 'E', 'I'],
      wildcardIndex: 1,
      wildcardIcon: Icons.lock,
      wildcardColor: AppColors.errorPrimary,
      blockedIndices: [],
      selectedIndex: -1,
      showBlockedLetters: false,
    ),
    TutorialStep(
      title: 'Comodín 4: Seleccionar Letra',
      description:
          'Toca la letra que quieres dejar disponible para el siguiente jugador',
      highlightKey: 'selectedLetter',
      playerName: 'Juan',
      playerScore: 20,
      categoryName: 'ANIMALES',
      chronometerTime: '00:06',
      letters: ['A', 'M', 'S', 'Ñ', 'E', 'I'],
      wildcardIndex: -1,
      wildcardIcon: Icons.lock,
      wildcardColor: AppColors.errorPrimary,
      blockedIndices: [],
      selectedIndex: 2,
      showBlockedLetters: false,
    ),
    TutorialStep(
      title: 'Comodín 4: Letras Bloqueadas',
      description:
          '¡Perfecto! Solo la letra "S" estará disponible para el siguiente jugador',
      highlightKey: 'blockedLetters',
      playerName: 'Daniel',
      playerScore: 0,
      categoryName: 'ANIMALES',
      chronometerTime: '00:10',
      letters: ['A', 'M', 'S', 'Ñ', 'E', 'I'],
      wildcardIndex: -1,
      wildcardIcon: Icons.lock,
      wildcardColor: AppColors.errorPrimary,
      blockedIndices: [0, 1, 3, 4, 5],
      selectedIndex: 2,
      showBlockedLetters: true,
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
              child: const Icon(Icons.stars, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Tutorial de Comodines',
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
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

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(16),
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

    return SizedBox(
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
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Opacity(
                    opacity: step.blockedIndices.contains(i) ? 0.5 : 1.0,
                    child: Container(
                      key:
                          (i == step.wildcardIndex ||
                              (step.selectedIndex == i &&
                                  step.highlightKey == 'selectedLetter'))
                          ? (step.highlightKey == 'selectedLetter'
                                ? _selectedLetterKey
                                : _wildcardLetterKey)
                          : null,
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(45),
                        border:
                            (step.selectedIndex == i &&
                                step.highlightKey == 'selectedLetter')
                            ? Border.all(color: AppColors.tertiary, width: 3)
                            : Border(
                                bottom: BorderSide(
                                  color: AppColors.secondaryVariant,
                                  width: 5,
                                ),
                              ),
                      ),
                      child: Center(
                        child: Text(
                          letters[i],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (i == step.wildcardIndex && step.wildcardIndex >= 0)
                    Positioned(
                      top: -5,
                      right: -5,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: step.wildcardColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          step.wildcardIcon,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  if (step.blockedIndices.contains(i))
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.red,
                        size: 32,
                      ),
                    ),
                ],
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
          colors: [step.wildcardColor, step.wildcardColor],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: step.wildcardColor.withValues(alpha: 0.3),
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
                  step.wildcardIcon,
                  color: step.wildcardColor,
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
                    color: step.wildcardColor,
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
                Icon(Icons.info_outline, color: step.wildcardColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    step.description,
                    style: GoogleFonts.poppins(
                      color: step.wildcardColor,
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
          wildcardLetterKey: _wildcardLetterKey,
          selectedLetterKey: _selectedLetterKey,
        ),
        child: const SizedBox.expand(),
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
  final int wildcardIndex;
  final IconData wildcardIcon;
  final Color wildcardColor;
  final List<int> blockedIndices;
  final int selectedIndex;
  final bool showBlockedLetters;

  TutorialStep({
    required this.title,
    required this.description,
    required this.highlightKey,
    required this.playerName,
    required this.playerScore,
    required this.categoryName,
    required this.chronometerTime,
    required this.letters,
    required this.wildcardIndex,
    required this.wildcardIcon,
    required this.wildcardColor,
    required this.blockedIndices,
    required this.selectedIndex,
    required this.showBlockedLetters,
  });
}

class SpotlightPainter extends CustomPainter {
  final String highlightKey;
  final GlobalKey wildcardLetterKey;
  final GlobalKey selectedLetterKey;

  SpotlightPainter({
    required this.highlightKey,
    required this.wildcardLetterKey,
    required this.selectedLetterKey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    RRect? highlightRect;

    switch (highlightKey) {
      case 'wildcardLetter':
        highlightRect = _getHighlightRect(
          wildcardLetterKey,
          padding: 12,
          isCircle: true,
        );
        break;
      case 'selectedLetter':
        highlightRect = _getHighlightRect(
          selectedLetterKey,
          padding: 12,
          isCircle: true,
        );
        break;
      case 'blockedLetters':
        return;
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
