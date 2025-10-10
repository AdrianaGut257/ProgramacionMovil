import 'dart:math';
import 'package:flutter/material.dart';

/// Tablero circular con 6 letras activas.
/// Mantiene un abecedario global interno (incluye Ñ). Cuando validas ✔
/// una letra, se elimina del abecedario global y del tablero.
/// Cuando se agotan, se repuebla el abecedario completo.
/// Callbacks:
/// - onOpenDialog(): notifica que se abre el modal (puedes pausar timer)
/// - onCloseDialog(bool? ok): notifica cierre (ok=true => ✔, false => ✖, null => dismiss)
/// - onValid(): notifica ✔ (p.ej. sumar punto/rotar/reset timer)
class LetterBoard extends StatefulWidget {
  final VoidCallback? onValid;
  final VoidCallback? onInvalid;
  final VoidCallback? onOpenDialog;
  final void Function(bool? ok)? onCloseDialog;

  final double size;
  final Color boardColor;
  final Color letterBg;
  final TextStyle? letterStyle;

  const LetterBoard({
    super.key,
    this.onValid,
    this.onInvalid,
    this.onOpenDialog,
    this.onCloseDialog,
    this.size = 320,
    this.boardColor = const Color(0xFF5B4BC4),
    this.letterBg = const Color(0xFF31D4C0),
    this.letterStyle,
  });

  @override
  State<LetterBoard> createState() => _LetterBoardState();
}

class _LetterBoardState extends State<LetterBoard> {
  static const List<String> _alphabetFull = [
    'A','B','C','D','E','F','G','H','I','J','K','L',
    'M','N','Ñ','O','P','Q','R','S','T','U','V','W','X','Y','Z'
  ];

  final Random _rng = Random();

  late List<String> _pool;     // abecedario restante (global en esta partida)
  late List<String> _letters;  // hasta 6 letras activas visibles

  @override
  void initState() {
    super.initState();
    _pool = List<String>.from(_alphabetFull);
    _letters = _takeUpTo(6);
  }

  List<String> _takeUpTo(int count) {
    // saca letras únicas al azar del pool global (sin reponer)
    final out = <String>[];
    while (out.length < count && _pool.isNotEmpty) {
      final idx = _rng.nextInt(_pool.length);
      out.add(_pool.removeAt(idx));
    }
    return out;
  }

  Future<void> _validateLetter(int index) async {
    widget.onOpenDialog?.call();
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _ValidationDialog(),
    );
    widget.onCloseDialog?.call(ok);

    if (ok == true) {
      // ✔ quita la letra del tablero (ya no está en pool) y repone si hay pool
      setState(() {
        _letters.removeAt(index);
        if (_letters.length < 6) {
          _letters.addAll(_takeUpTo(6 - _letters.length));
        }
        // Si pool se agotó y también tablero, repoblamos abecedario completo
        if (_letters.isEmpty && _pool.isEmpty) {
          _pool = List<String>.from(_alphabetFull);
          _letters = _takeUpTo(6);
        }
      });
      widget.onValid?.call();
    } else if (ok == false) {
      widget.onInvalid?.call();
    } else {
      // dismissed -> no hacemos nada especial
    }
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;
    final double radius = size / 2;
    final double bubble = size * 0.22;
    final double innerRadius = size * 0.33;

    final angles = <double>[-90, -30, 30, 90, 150, -150]
        .map((d) => d * pi / 180)
        .toList();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // círculo grande
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: widget.boardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
          ),

          // centro decorativo
          Container(
            width: bubble * 0.9,
            height: bubble * 0.9,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF2993A),
            ),
            child: Center(
              child: Container(
                width: bubble * 0.45,
                height: bubble * 0.45,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE07A),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // burbujas de letras
          for (int i = 0; i < _letters.length && i < 6; i++)
            Positioned(
              left: radius + innerRadius * cos(angles[i]) - bubble / 2,
              top:  radius + innerRadius * sin(angles[i]) - bubble / 2,
              child: _LetterBubble(
                letter: _letters[i],
                size: bubble,
                color: widget.letterBg,
                textStyle: widget.letterStyle ??
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 26,
                    ),
                onTap: () => _validateLetter(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _LetterBubble extends StatelessWidget {
  final String letter;
  final double size;
  final Color color;
  final TextStyle textStyle;
  final VoidCallback onTap;

  const _LetterBubble({
    required this.letter,
    required this.size,
    required this.color,
    required this.textStyle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkResponse(
        radius: size / 2 + 8,
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                offset: const Offset(0, 6),
                blurRadius: 12,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(letter, style: textStyle),
        ),
      ),
    );
  }
}

class _ValidationDialog extends StatelessWidget {
  const _ValidationDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // icono
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEEF1FF),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: const Icon(Icons.quiz_outlined, color: Color(0xFF5B4BC4)),
            ),
            const SizedBox(height: 14),
            const Text('Valida la respuesta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Container(
              width: 50,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFF31D4C0),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _RoundActionButton(
                  bg: const Color(0xFF31D4C0),
                  icon: Icons.check,
                  onTap: () => Navigator.pop(context, true),
                ),
                _RoundActionButton(
                  bg: const Color(0xFFE64A64),
                  icon: Icons.close,
                  onTap: () => Navigator.pop(context, false),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  final Color bg;
  final IconData icon;
  final VoidCallback onTap;

  const _RoundActionButton({
    required this.bg,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkResponse(
        radius: 44,
        onTap: onTap,
        child: Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 34),
        ),
      ),
    );
  }
}
