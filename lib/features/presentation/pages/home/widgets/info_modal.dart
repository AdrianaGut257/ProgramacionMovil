import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';

class InfoModal {
  static void show(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required bool showComoJugar,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      builder: (context) => _InfoModalContent(
        title: title,
        icon: icon,
        color: color,
        showComoJugar: showComoJugar,
      ),
    );
  }
}

class _InfoModalContent extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool showComoJugar;

  const _InfoModalContent({
    required this.title,
    required this.icon,
    required this.color,
    required this.showComoJugar,
  });

  @override
  State<_InfoModalContent> createState() => _InfoModalContentState();
}

class _InfoModalContentState extends State<_InfoModalContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final isSmall = size.width < 360;

    final maxHeight = size.height - padding.top - 50;
    final modalHeight = (maxHeight * 0.8).clamp(300.0, maxHeight);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        height: modalHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),

            Container(
              padding: EdgeInsets.all(isSmall ? 18 : 22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryVariant],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isSmall ? 12 : 14),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white70, width: 2),
                    ),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: isSmall ? 26 : 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmall ? 22 : 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.showComoJugar
                              ? 'Guía paso a paso'
                              : 'Normas del juego',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 16,
                  left: isSmall ? 16 : 20,
                  right: isSmall ? 16 : 20,
                  top: 20,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: widget.showComoJugar
                      ? _buildComoJugar(isSmall)
                      : _buildReglas(isSmall),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComoJugar(bool small) {
    final items = [
      {
        'icon': Icons.person_add_alt_1_rounded,
        'text': 'Registra el nombre de cada jugador',
        'color': AppColors.primary,
        'step': '1',
      },
      {
        'icon': Icons.extension_rounded,
        'text': 'Elige comodines para hacer el juego más dinámico',
        'color': AppColors.secondary,
        'step': '2',
      },
      {
        'icon': Icons.category_rounded,
        'text': 'Selecciona una categoría del catálogo disponible',
        'color': AppColors.primary,
        'step': '3',
      },
      {
        'icon': Icons.add_circle_outline_rounded,
        'text': 'Crea categorías personalizadas para más diversión',
        'color': AppColors.secondary,
        'step': '4',
      },
      {
        'icon': Icons.abc_rounded,
        'text': 'Selecciona una letra del abecedario',
        'color': AppColors.primary,
        'step': '5',
      },
      {
        'icon': Icons.timer_outlined,
        'text': 'Responde antes de que se acabe el tiempo',
        'color': AppColors.secondary,
        'step': '6',
      },
      {
        'icon': Icons.lightbulb_outline_rounded,
        'text': 'Tu palabra debe empezar con la letra elegida',
        'color': AppColors.primary,
        'step': '7',
      },
      {
        'icon': Icons.how_to_vote_rounded,
        'text': 'Los jugadores validan si la respuesta es correcta',
        'color': AppColors.secondary,
        'step': '8',
      },
      {
        'icon': Icons.emoji_events_rounded,
        'text': 'Gana puntos por cada respuesta acertada',
        'color': AppColors.primary,
        'step': '9',
      },
      {
        'icon': Icons.warning_amber_rounded,
        'text': 'No responder a tiempo significa perder el turno',
        'color': AppColors.secondary,
        'step': '10',
      },
    ];

    return _buildAnimatedList(items, small);
  }

  Widget _buildReglas(bool small) {
    final items = [
      {
        'icon': Icons.badge_rounded,
        'text': 'Registra tu nombre para participar',
        'color': AppColors.primary,
        'step': '1',
      },
      {
        'icon': Icons.category_outlined,
        'text': 'Selecciona una categoría del juego',
        'color': AppColors.secondary,
        'step': '2',
      },
      {
        'icon': Icons.looks_one_rounded,
        'text': 'Se elige una sola letra por turno',
        'color': AppColors.primary,
        'step': '3',
      },
      {
        'icon': Icons.spellcheck_rounded,
        'text': 'La palabra debe pertenecer a la categoría',
        'color': AppColors.secondary,
        'step': '4',
      },
      {
        'icon': Icons.schedule_rounded,
        'text': 'Tiempos: 10s (Fácil) • 5s (Difícil/Grupal)',
        'color': AppColors.primary,
        'step': '5',
      },
      {
        'icon': Icons.check_circle_outline_rounded,
        'text': 'Respuesta correcta suma puntos',
        'color': AppColors.secondary,
        'step': '6',
      },
      {
        'icon': Icons.cancel_outlined,
        'text': 'Fallar elimina en Difícil, resta en otros modos',
        'color': AppColors.primary,
        'step': '7',
      },
      {
        'icon': Icons.groups_rounded,
        'text': 'Valida respuestas junto a otros jugadores',
        'color': AppColors.secondary,
        'step': '8',
      },
      {
        'icon': Icons.workspace_premium_rounded,
        'text': 'Gana quien tenga más puntos al final',
        'color': AppColors.primary,
        'step': '9',
      },
    ];

    return _buildAnimatedList(items, small);
  }

  Widget _buildAnimatedList(List<Map<String, dynamic>> items, bool small) {
    return Column(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: _buildStepCard(item, small),
        );
      }).toList(),
    );
  }

  Widget _buildStepCard(Map<String, dynamic> item, bool small) {
    final color = item['color'] as Color;

    return Container(
      margin: EdgeInsets.only(bottom: small ? 14 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(small ? 14 : 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: small ? 48 : 52,
                  height: small ? 48 : 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                Icon(
                  item['icon'] as IconData,
                  color: Colors.white,
                  size: small ? 24 : 26,
                ),
              ],
            ),
            SizedBox(width: small ? 14 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: color == AppColors.primary
                              ? AppColors.primaryVariant
                              : AppColors.secondaryVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Paso ${item['step']}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['text'] as String,
                    style: TextStyle(
                      fontSize: small ? 14 : 15,
                      color: Colors.grey[800],
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
