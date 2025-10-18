import 'dart:math';
import 'package:flutter/material.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board/widgets/letter_tile.dart.dart';
import 'package:programacion_movil/config/colors.dart';

enum WildcardType { skipTurn, extraTime, doublePoints, blockLetters }

class WildcardInfo {
  final WildcardType type;
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  WildcardInfo({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class LetterWithWildcard {
  final String letter;
  final WildcardInfo? wildcard;

  LetterWithWildcard({required this.letter, this.wildcard});
}

class BoardGameWildcards extends StatefulWidget {
  final VoidCallback? onLetterSelected;
  final Function(WildcardType)? onWildcardActivated;
  final Function(int)? onExtraTimeGranted;

  const BoardGameWildcards({
    super.key,
    this.onLetterSelected,
    this.onWildcardActivated,
    this.onExtraTimeGranted,
  });

  @override
  State<BoardGameWildcards> createState() => _BoardGameWildcardsState();
}

class _BoardGameWildcardsState extends State<BoardGameWildcards> {
  List<String> availableLetters = [];
  List<LetterWithWildcard> currentLetters = [];
  Set<int> blockedLetterIndices = {};
  bool doublePointsActive = false;
  int extraTimeSeconds = 0;
  WildcardInfo? pendingBlockWildcard;

  final List<String> spanishAlphabet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'Ñ',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  final List<WildcardInfo> allWildcards = [
    WildcardInfo(
      type: WildcardType.skipTurn,
      name: 'Saltar Turno',
      description: 'Salta tu turno y pasa al siguiente jugador',
      icon: Icons.skip_next,
      color: Colors.blue,
    ),
    WildcardInfo(
      type: WildcardType.extraTime,
      name: '+5 Segundos',
      description: 'Obtén 5 segundos adicionales',
      icon: Icons.timer,
      color: Colors.green,
    ),
    WildcardInfo(
      type: WildcardType.doublePoints,
      name: 'Doble Puntos',
      description: 'Duplica la puntuación de esta palabra',
      icon: Icons.star,
      color: Colors.amber,
    ),
    WildcardInfo(
      type: WildcardType.blockLetters,
      name: 'Bloquear Letras',
      description: 'Elige 1 letra y bloquea las demás',
      icon: Icons.lock,
      color: Colors.red,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    setState(() {
      availableLetters = List.from(spanishAlphabet);
      availableLetters.shuffle();

      currentLetters = [];

      for (int i = 0; i < 6; i++) {
        if (availableLetters.isEmpty) break;

        final letter = availableLetters.removeAt(0);
        final random = Random();

        WildcardInfo? wildcard;
        if (random.nextDouble() < 0.3) {
          wildcard = allWildcards[random.nextInt(allWildcards.length)];
        }

        currentLetters.add(
          LetterWithWildcard(letter: letter, wildcard: wildcard),
        );
      }

      blockedLetterIndices.clear();
      doublePointsActive = false;
      extraTimeSeconds = 0;
      pendingBlockWildcard = null;
    });
  }

  void _onLetterPressed(int index) {
    if (blockedLetterIndices.contains(index)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Esta letra está bloqueada'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (pendingBlockWildcard != null) {
      _selectLetterToKeep(index);
      return;
    }

    final letterWithWildcard = currentLetters[index];

    if (letterWithWildcard.wildcard != null) {
      _activateWildcard(letterWithWildcard.wildcard!, index);
    }

    setState(() {
      if (availableLetters.isNotEmpty) {
        final random = Random();
        final newLetter = availableLetters.removeAt(
          random.nextInt(availableLetters.length),
        );

        WildcardInfo? newWildcard;
        if (random.nextDouble() < 0.3) {
          newWildcard = allWildcards[random.nextInt(allWildcards.length)];
        }

        currentLetters[index] = LetterWithWildcard(
          letter: newLetter,
          wildcard: newWildcard,
        );
      }

      widget.onLetterSelected?.call();
    });
  }

  void _activateWildcard(WildcardInfo wildcard, int index) {
    switch (wildcard.type) {
      case WildcardType.skipTurn:
        _handleSkipTurn();
        break;
      case WildcardType.extraTime:
        _handleExtraTime();
        break;
      case WildcardType.doublePoints:
        _handleDoublePoints();
        break;
      case WildcardType.blockLetters:
        _handleBlockLetters(wildcard);
        break;
    }

    widget.onWildcardActivated?.call(wildcard.type);
  }

  void _handleSkipTurn() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.skip_next, color: Colors.white),
            SizedBox(width: 8),
            Text('¡Turno saltado!'),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleExtraTime() {
    setState(() {
      extraTimeSeconds += 5;
    });
    widget.onExtraTimeGranted?.call(5);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.timer, color: Colors.white),
            SizedBox(width: 8),
            Text('¡+5 segundos agregados!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleDoublePoints() {
    setState(() {
      doublePointsActive = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.star, color: Colors.white),
            SizedBox(width: 8),
            Text('¡Puntos duplicados activados!'),
          ],
        ),
        backgroundColor: Colors.amber,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleBlockLetters(WildcardInfo wildcard) {
    setState(() {
      pendingBlockWildcard = wildcard;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.lock, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Selecciona la letra que deseas mantener desbloqueada',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _selectLetterToKeep(int index) {
    setState(() {
      blockedLetterIndices.clear();
      for (int i = 0; i < currentLetters.length; i++) {
        if (i != index) {
          blockedLetterIndices.add(i);
        }
      }
      pendingBlockWildcard = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Letra ${currentLetters[index].letter} desbloqueada. Las demás bloqueadas para el próximo jugador.',
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double radius = 120;

    return Column(
      children: [
        if (doublePointsActive ||
            extraTimeSeconds > 0 ||
            blockedLetterIndices.isNotEmpty ||
            pendingBlockWildcard != null)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (doublePointsActive)
                  const Chip(
                    avatar: Icon(Icons.star, color: Colors.white, size: 16),
                    label: Text(
                      'Doble Puntos',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.amber,
                  ),
                if (extraTimeSeconds > 0)
                  Chip(
                    avatar: const Icon(
                      Icons.timer,
                      color: Colors.white,
                      size: 16,
                    ),
                    label: Text(
                      '+$extraTimeSeconds seg',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  ),
                if (blockedLetterIndices.isNotEmpty)
                  Chip(
                    avatar: const Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 16,
                    ),
                    label: Text(
                      '${blockedLetterIndices.length} bloqueadas',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                if (pendingBlockWildcard != null)
                  const Chip(
                    avatar: Icon(
                      Icons.touch_app,
                      color: Colors.white,
                      size: 16,
                    ),
                    label: Text(
                      'Selecciona una letra',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.orange,
                  ),
              ],
            ),
          ),

        SizedBox(
          width: 360,
          height: 360,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 380,
                height: 380,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),

              for (int i = 0; i < currentLetters.length; i++)
                Transform.translate(
                  offset: Offset(
                    radius * cos(2 * pi * i / currentLetters.length - pi / 2),
                    radius * sin(2 * pi * i / currentLetters.length - pi / 2),
                  ),
                  child: GestureDetector(
                    onTap: () => _onLetterPressed(i),
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Opacity(
                          opacity: blockedLetterIndices.contains(i) ? 0.5 : 1.0,
                          child: Builder(
                            builder: (context) => LetterTile(
                              letter: currentLetters[i].letter,
                              onTap: () => _onLetterPressed(i),
                              availableLetters: availableLetters.length,
                            ),
                          ),
                        ),

                        if (currentLetters[i].wildcard != null)
                          Positioned(
                            top: -5,
                            right: -5,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: currentLetters[i].wildcard!.color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                currentLetters[i].wildcard!.icon,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),

                        if (blockedLetterIndices.contains(i))
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock,
                              color: Colors.red,
                              size: 32,
                            ),
                          ),

                        if (pendingBlockWildcard != null &&
                            !blockedLetterIndices.contains(i))
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.yellow,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Comodines',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: allWildcards.map((wildcard) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: wildcard.color,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          wildcard.icon,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(wildcard.name, style: const TextStyle(fontSize: 12)),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
