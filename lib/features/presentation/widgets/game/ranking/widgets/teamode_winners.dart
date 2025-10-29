import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:programacion_movil/config/colors.dart';
import '../utils/screen_config.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/custom_button.dart';

class TeamModeWinnersScreen extends StatefulWidget {
  final Map<String, int> playerScores;
  final List<dynamic> orderedPlayers;

  const TeamModeWinnersScreen({
    super.key,
    required this.playerScores,
    required this.orderedPlayers,
  });

  @override
  State<TeamModeWinnersScreen> createState() => _TeamModeWinnersScreenState();
}

class _TeamModeWinnersScreenState extends State<TeamModeWinnersScreen>
    with TickerProviderStateMixin {
  late Map<int, int> teamScores;
  late Map<int, List<MapEntry<String, int>>> teamPlayers;
  late int winnerTeam;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _trophyController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _trophyScale;

  @override
  void initState() {
    super.initState();
    _calculateTeamScores();
    _initAnimations();
  }

  void _calculateTeamScores() {
    teamScores = {1: 0, 2: 0};
    teamPlayers = {1: [], 2: []};

    // Sumar puntos por equipo y agrupar jugadores
    for (var player in widget.orderedPlayers) {
      final playerName = player.name;
      final team = player.team;
      final score = widget.playerScores[playerName] ?? 0;

      teamScores[team] = (teamScores[team] ?? 0) + score;
      teamPlayers[team]?.add(MapEntry(playerName, score));
    }

    // Ordenar jugadores dentro de cada equipo por puntaje
    teamPlayers[1]?.sort((a, b) => b.value.compareTo(a.value));
    teamPlayers[2]?.sort((a, b) => b.value.compareTo(a.value));

    // Determinar equipo ganador
    winnerTeam = (teamScores[1] ?? 0) > (teamScores[2] ?? 0) ? 1 : 2;
    
    // Si hay empate, ambos equipos son ganadores
    if (teamScores[1] == teamScores[2]) {
      winnerTeam = 0; // 0 indica empate
    }
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _trophyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _trophyScale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _trophyController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _trophyController.dispose();
    super.dispose();
  }

  Color _getTeamColor(int team) {
    return team == 1 ? AppColors.tertiary : AppColors.secondary;
  }

  Color _getTeamVariantColor(int team) {
    return team == 1 ? AppColors.tertiaryVariant : AppColors.secondaryVariant;
  }

  Widget _buildWinnerBanner(ScreenConfig config) {
    String title;
    IconData icon;
    List<Color> colors;

    if (winnerTeam == 0) {
      title = '¡EMPATE!';
      icon = Icons.handshake_rounded;
      colors = [AppColors.primary, AppColors.primaryVariant];
    } else {
      title = 'EQUIPO $winnerTeam GANADOR';
      icon = Icons.emoji_events_rounded;
      colors = [_getTeamColor(winnerTeam), _getTeamVariantColor(winnerTeam)];
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: colors.first.withOpacity(0.5),
            offset: const Offset(0, 6),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        children: [
          ScaleTransition(
            scale: _trophyScale,
            child: Icon(
              icon,
              color: Colors.white,
              size: config.size.width * 0.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: config.size.width * 0.065,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          if (winnerTeam != 0) ...[
            const SizedBox(height: 8),
            Text(
              '${teamScores[winnerTeam]} PUNTOS',
              style: TextStyle(
                fontSize: config.size.width * 0.045,
                fontWeight: FontWeight.w600,
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTeamCard(int team, ScreenConfig config) {
    final players = teamPlayers[team] ?? [];
    final totalScore = teamScores[team] ?? 0;
    final isWinner = (winnerTeam == team) || (winnerTeam == 0);
    final teamColor = _getTeamColor(team);
    final teamVariantColor = _getTeamVariantColor(team);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // ignore: deprecated_member_use
          colors: [teamColor.withOpacity(0.15), teamVariantColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          // ignore: deprecated_member_use
          color: isWinner ? teamColor : teamColor.withOpacity(0.3),
          width: isWinner ? 3 : 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del equipo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [teamColor, teamVariantColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.groups_rounded,
                        color: teamColor,
                        size: config.size.width * 0.06,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'EQUIPO $team',
                      style: TextStyle(
                        fontSize: config.size.width * 0.05,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$totalScore pts',
                    style: TextStyle(
                      fontSize: config.size.width * 0.045,
                      fontWeight: FontWeight.bold,
                      color: teamColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista de jugadores
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: players.map((player) {
                final index = players.indexOf(player);
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      // ignore: deprecated_member_use
                      color: teamColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Posición en el equipo
                      Container(
                        width: config.size.width * 0.08,
                        height: config.size.width * 0.08,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [teamColor, teamVariantColor],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: config.size.width * 0.035,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Nombre del jugador
                      Expanded(
                        child: Text(
                          player.key,
                          style: TextStyle(
                            fontSize: config.size.width * 0.04,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      // Puntos individuales
                      Text(
                        '${player.value}',
                        style: TextStyle(
                          fontSize: config.size.width * 0.042,
                          fontWeight: FontWeight.bold,
                          color: teamColor,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = ScreenConfig(MediaQuery.of(context).size);
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final isSmallScreen = height < 700;

    return Scaffold(
      backgroundColor: AppColors.primaryVariant,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(config.horizontalPadding),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Título
                Text(
                   'Ranking',
                        style: GoogleFonts.titanOne().copyWith(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: AppColors.success,
                          letterSpacing: 0,
                          height: 1.1,
                        ),
                        textAlign: TextAlign.center,
              
                ),
                
                const SizedBox(height: 20),
                
                // Banner del ganador
                _buildWinnerBanner(config),
                
                const SizedBox(height: 30),
                
                // Cards de equipos
                SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      // Mostrar primero el equipo ganador
                      if (winnerTeam == 1 || winnerTeam == 0)
                        _buildTeamCard(1, config),
                      if (winnerTeam == 2 || winnerTeam == 0)
                        _buildTeamCard(2, config),
                      if (winnerTeam == 1)
                        _buildTeamCard(2, config),
                      if (winnerTeam == 2)
                        _buildTeamCard(1, config),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                CustomButton(
                  text: 'Volver al inicio',
                  icon: Icons.home,
                  backgroundColor: AppColors.secondary,
                  textColor: AppColors.white,
                  borderColor: AppColors.secondaryVariant,
                  onPressed: () => context.push('/'),
                ),
                
                SizedBox(height: isSmallScreen ? 10 : 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}