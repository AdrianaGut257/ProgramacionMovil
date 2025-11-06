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

    for (var player in widget.orderedPlayers) {
      final playerName = player.name;
      final team = player.team;
      final score = widget.playerScores[playerName] ?? 0;

      teamScores[team] = (teamScores[team] ?? 0) + score;
      teamPlayers[team]?.add(MapEntry(playerName, score));
    }

    teamPlayers[1]?.sort((a, b) => b.value.compareTo(a.value));
    teamPlayers[2]?.sort((a, b) => b.value.compareTo(a.value));

    winnerTeam = (teamScores[1] ?? 0) > (teamScores[2] ?? 0) ? 1 : 2;

    if (teamScores[1] == teamScores[2]) {
      winnerTeam = 0;
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

  Color _getTeamColor(int team) =>
      team == 1 ? AppColors.tertiary : AppColors.secondary;

  Color _getTeamVariantColor(int team) =>
      team == 1 ? AppColors.tertiaryVariant : AppColors.secondaryVariant;

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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: colors.first.withOpacity(0.5),
            offset: const Offset(0, 4),
            blurRadius: 10,
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
              size: config.size.width * 0.13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: config.size.width * 0.05,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          if (winnerTeam != 0)
            Text(
              '${teamScores[winnerTeam]} PUNTOS',
              style: TextStyle(
                fontSize: config.size.width * 0.04,
                fontWeight: FontWeight.w600,
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.9),
              ),
            ),
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
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // ignore: deprecated_member_use
          colors: [teamColor.withOpacity(0.12), teamVariantColor.withOpacity(0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // ignore: deprecated_member_use
          color: isWinner ? teamColor : teamColor.withOpacity(0.3),
          width: isWinner ? 2.5 : 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [teamColor, teamVariantColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.groups_rounded,
                        color: Colors.white,
                        size: config.size.width * 0.045),
                    const SizedBox(width: 8),
                    Text(
                      'EQUIPO $team',
                      style: TextStyle(
                        fontSize: config.size.width * 0.04,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$totalScore pts',
                  style: TextStyle(
                    fontSize: config.size.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: players.map((player) {
                final index = players.indexOf(player);
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    // ignore: deprecated_member_use
                    border: Border.all(color: teamColor.withOpacity(0.15), width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: config.size.width * 0.065,
                        height: config.size.width * 0.065,
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
                              fontSize: config.size.width * 0.032,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          player.key,
                          style: TextStyle(
                            fontSize: config.size.width * 0.036,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${player.value}',
                        style: TextStyle(
                          fontSize: config.size.width * 0.038,
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
          padding: EdgeInsets.all(config.horizontalPadding * 0.8),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                Text(
                  'Ranking',
                  style: GoogleFonts.titanOne().copyWith(
                    fontSize: config.size.width * 0.08, // antes 35
                    fontWeight: FontWeight.w900,
                    color: AppColors.success,
                    letterSpacing: 0,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _buildWinnerBanner(config),
                const SizedBox(height: 24),
                SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
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
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Volver al inicio',
                  icon: Icons.home,
                  backgroundColor: AppColors.secondary,
                  textColor: AppColors.white,
                  borderColor: AppColors.secondaryVariant,
                  onPressed: () => context.push('/'),
                ),
                SizedBox(height: isSmallScreen ? 10 : 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
