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

class _InfoModalContent extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final isSmall = size.width < 360;

    final maxHeight = size.height - padding.top - 50;
    final modalHeight = (maxHeight * 0.78).clamp(300.0, maxHeight);

    return Container(
      height: modalHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryVariant,
            AppColors.primary,
            const Color(0xFF3D2C5E),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 45,
            height: 5,
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.35),
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmall ? 16 : 22,
              vertical: 8,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isSmall ? 8 : 10),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: color.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: isSmall ? 23 : 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmall ? 22 : 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ignore: deprecated_member_use
          Divider(color: Colors.white.withOpacity(0.25), height: 1),

          // Scroll content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 22, // Asegura espacio inferior SIEMPRE
                left: isSmall ? 16 : 22,
                right: isSmall ? 16 : 22,
                top: 14,
              ),
              child: SingleChildScrollView(
                child: showComoJugar
                    ? _buildComoJugar(isSmall)
                    : _buildReglas(isSmall),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComoJugar(bool small) {
    final items = [
      {
        'icon': Icons.person_add_alt_1_rounded,
        'text': 'Registra el nombre de cada jugador.'
      },
      {
        'icon': Icons.extension_rounded,
        'text': 'Elige si deseas jugar con comodines (puedes elegir algunos o todos).'
      },
      {
        'icon': Icons.category_rounded,
        'text':
            'Selecciona una categoría predefinida (países, animales, frutas, etc.).'
      },
      {
        'icon': Icons.add_circle_outline_rounded,
        'text':
            'Si deseas, puedes crear tu propia categoría personalizada para variar el juego.'
      },
      {
        'icon': Icons.abc_rounded,
        'text': 'Selecciona una letra del abecedario para comenzar la ronda.'
      },
      {
        'icon': Icons.hourglass_empty_rounded,
        'text':
            'Tendrás un tiempo limitado para responder (10s modo Fácil — 5s modo Difícil y Grupal).'
      },
      {
        'icon': Icons.check_circle_rounded,
        'text':
            'Tu palabra debe comenzar con la letra elegida y pertenecer a la categoría seleccionada.'
      },
      {
        'icon': Icons.how_to_vote_rounded,
        'text':
            'Los demás jugadores pueden validar si tu palabra es correcta.'
      },
      {
        'icon': Icons.star_rate_rounded,
        'text': 'Responde correctamente para ganar puntos.'
      },
      {
        'icon': Icons.warning_amber_rounded,
        'text': 'Si no respondes a tiempo, pierdes tu turno (o la partida en modo Difícil).'
      },
    ];

    return _buildList(items, small);
  }

  Widget _buildReglas(bool small) {
    final items = [
      {'icon': Icons.login, 'text': 'Cada jugador debe registrarse con un nombre.'},
      {
        'icon': Icons.category,
        'text':
            'Debes elegir una categoría (predefinida o creada).'
      },
      {'icon': Icons.abc_rounded, 'text': 'Solo se selecciona una letra por turno.'},
      {
        'icon': Icons.text_fields_rounded,
        'text':
            'La palabra debe empezar con esa letra y pertenecer a la categoría.'
      },
      {
        'icon': Icons.timer_rounded,
        'text':
            'Tiempo de respuesta: 10s Fácil — 5s Difícil — 5s Grupal.'
      },
      {
        'icon': Icons.check_circle_outline,
        'text': 'Si la respuesta es correcta, ganas puntos.'
      },
      {
        'icon': Icons.close_rounded,
        'text':
            'Si fallas o no respondes: en Fácil/Grupal solo pierdes puntos; en Difícil quedas eliminado.'
      },
      {
        'icon': Icons.group_rounded,
        'text':
            'Los jugadores pueden validar si la palabra es válida.'
      },
      {
        'icon': Icons.emoji_events_rounded,
        'text':
            'Gana quien acumule más puntos (o el último en pie en Modo Difícil).'
      },
      
    ];

    return _buildList(items, small);
  }
  

  Widget _buildList(List<Map<String, dynamic>> items, bool small) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: small ? 12 : 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(small ? 6 : 8),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: AppColors.secondary.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      e['icon'],
                      size: small ? 18 : 20,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(width: small ? 12 : 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e['text'],
                          style: TextStyle(
                            fontSize: small ? 14 : 16,
                            color: Colors.white,
                            height: 1.45,
                          ),
                        ),
                        SizedBox(height: small ? 8 : 19), 
                      ],
                    ),
                  ),
                  
                ],
                
              ),
              
            ),
            
          )
          .toList(),
          
    );
  }
}
