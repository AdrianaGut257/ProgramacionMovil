import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/back_button_custom.dart';
import 'package:programacion_movil/features/presentation/widgets/information/modality_information.dart';
import '../../widgets/buttons/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:programacion_movil/features/presentation/state/game_team.dart';
import 'package:programacion_movil/features/presentation/state/game_individual.dart';

class ComodinesPage extends StatefulWidget {
  const ComodinesPage({super.key});

  @override
  State<ComodinesPage> createState() => _ComodinesPageState();
}

class _ComodinesPageState extends State<ComodinesPage>
    with TickerProviderStateMixin {
  final Map<String, bool> _selectedPowerUps = {
    'tiempo_extra': false,
    'saltar_turno': false,
    'punto_doble': false,
    'castigo_leve': false,
  };

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Cargar comodines guardados según el modo
      final state = GoRouterState.of(context);
      final extras = state.extra as Map<String, dynamic>? ?? {};
      final mode = extras['mode'] ?? 'group';

      List<String> savedWildcards = [];
      
      if (mode == 'individual') {
        final gameIndividual = context.read<GameIndividual>();
        savedWildcards = gameIndividual.selectedWildcards;
      } else {
        final gameTeam = context.read<GameTeam>();
        savedWildcards = gameTeam.selectedWildcards;
      }

      if (savedWildcards.isNotEmpty) {
        setState(() {
          for (var wildcard in savedWildcards) {
            if (_selectedPowerUps.containsKey(wildcard)) {
              _selectedPowerUps[wildcard] = true;
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _togglePowerUp(String key) {
    setState(() {
      _selectedPowerUps[key] = !_selectedPowerUps[key]!;
    });
  }

  int get _selectedCount =>
      _selectedPowerUps.values.where((selected) => selected).length;

  bool get _hasSelection => _selectedCount > 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final isSmallScreen = height < 700;

    // 🔹 Obtener parámetros desde GoRouter
    final state = GoRouterState.of(context);
    final extras = state.extra as Map<String, dynamic>? ?? {};

    final mode = extras['mode'] ?? 'group';
    final players = extras['players'];
    final difficulty = extras['difficulty'] ?? 'easy';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          BackButtonCustom(onPressed: () => context.pop()),
                          const Spacer(),
                        ],
                      ),

                      Text(
                        'Comodines',
                        style: GoogleFonts.titanOne().copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          letterSpacing: 0,
                          height: 1.1,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: isSmallScreen ? 12 : 24),

                      _buildHelpGuide(width, isSmallScreen),

                      SizedBox(height: isSmallScreen ? 12 : 20),

                      _buildSelectionCounter(width),

                      SizedBox(height: isSmallScreen ? 12 : 16),

                      SelectableComodinCards(
                        leftAssetPath: 'assets/icons/gestion-del-tiempo.png',
                        leftTitle: 'Tiempo extra',
                        leftValue:
                            'Podrá tener 5 segundos extras para decir la palabra.',
                        leftKey: 'tiempo_extra',
                        leftSelected: _selectedPowerUps['tiempo_extra']!,
                        onLeftTap: () => _togglePowerUp('tiempo_extra'),
                        rightAssetPath: 'assets/icons/espada.png',
                        rightTitle: 'Saltar turno',
                        rightValue:
                            'Permite saltar el turno e ir directamente hacia la siguiente persona.',
                        rightKey: 'saltar_turno',
                        rightSelected: _selectedPowerUps['saltar_turno']!,
                        onRightTap: () => _togglePowerUp('saltar_turno'),
                        cardColor: AppColors.tertiary,
                      ),

                      SizedBox(height: isSmallScreen ? 10 : 15),

                      SelectableComodinCards(
                        leftAssetPath: 'assets/icons/apuesta.png',
                        leftTitle: 'Punto doble',
                        leftValue:
                            'Podrá activar el doble de la puntuación al decir la palabra.',
                        leftKey: 'punto_doble',
                        leftSelected: _selectedPowerUps['punto_doble']!,
                        onLeftTap: () => _togglePowerUp('punto_doble'),
                        rightAssetPath: 'assets/icons/prision.png',
                        rightTitle: 'Castigo leve',
                        rightValue:
                            'Se elige 1 letra y las demás se bloquean para la próxima persona.',
                        rightKey: 'castigo_leve',
                        rightSelected: _selectedPowerUps['castigo_leve']!,
                        onRightTap: () => _togglePowerUp('castigo_leve'),
                        cardColor: AppColors.tertiary,
                      ),

                      SizedBox(height: isSmallScreen ? 16 : 24),

                      _buildPlayButton(isSmallScreen, mode, players, difficulty),

                      SizedBox(height: height * 0.05),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHelpGuide(double width, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.lightbulb_outline,
              color: Colors.white,
              size: width * 0.06,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Cómo funciona?',
                  style: GoogleFonts.blackOpsOne(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Toca las tarjetas para seleccionar los comodines que quieres usar en el juego',
                  style: TextStyle(
                    fontSize: width * 0.032,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCounter(double width) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: _hasSelection
            ? AppColors.secondary.withValues(alpha: 0.15)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _hasSelection
              ? AppColors.secondary
              : Colors.grey.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            color: _hasSelection ? AppColors.secondary : Colors.grey,
            size: width * 0.05,
          ),
          const SizedBox(width: 8),
          Text(
            _hasSelection
                ? '$_selectedCount comodín${_selectedCount > 1 ? 'es' : ''} seleccionado${_selectedCount > 1 ? 's' : ''}'
                : 'Ningún comodín seleccionado',
            style: GoogleFonts.blackOpsOne(
              fontSize: width * 0.035,
              color: _hasSelection ? AppColors.secondary : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton(
      bool isSmallScreen, String mode, dynamic players, String difficulty) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _hasSelection ? 1.0 + (_pulseController.value * 0.03) : 1.0,
          child: CustomButton(
            text: _hasSelection ? "Jugar con comodines" : "Jugar sin comodines",
            icon: Icons.play_arrow,
            backgroundColor: AppColors.secondary,
            textColor: Colors.white,
            borderColor: AppColors.secondaryVariant,
            onPressed: () {
              // Obtener comodines seleccionados
              final selectedPowerUps = _selectedPowerUps.entries
                  .where((entry) => entry.value)
                  .map((entry) => entry.key) 
                  .toList();

              debugPrint('=== COMODINES SELECCIONADOS ===');
              debugPrint('Modo: $mode');
              debugPrint('Comodines: $selectedPowerUps');

              // GUARDAR EN EL PROVIDER CORRECTO SEGÚN EL MODO
              if (mode == 'individual') {
                final gameIndividual = context.read<GameIndividual>();
                gameIndividual.setWildcards(selectedPowerUps);
                debugPrint('Guardado en GameIndividual');

                // Navegar al selector de categorías (modo individual)
                context.push(
                  '/select-categories',
                  extra: {
                    'mode': 'individual',
                    'players': players,
                    'difficulty': difficulty,
                    'powerUps': selectedPowerUps,
                  },
                );
              } else {
                final gameTeam = context.read<GameTeam>();
                gameTeam.setWildcards(selectedPowerUps);
                debugPrint('Guardado en GameTeam');

                // Navegar al selector de categorías (modo grupal)
                context.push(
                  '/select-categories',
                  extra: {
                    'mode': 'group',
                    'powerUps': selectedPowerUps,
                  },
                );
              }
            },
          ),
          
        );
      },
    );
  }
}