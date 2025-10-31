import 'package:flutter/material.dart';
import 'package:programacion_movil/data/datasources/app_database.dart';
import 'package:programacion_movil/features/presentation/pages/record_categories/widgets/ranking/ranking_list.dart';
import 'package:programacion_movil/features/presentation/pages/record_categories/widgets/record_header.dart';
import 'package:programacion_movil/features/presentation/pages/record_categories/widgets/record_tab_bar.dart';
import 'package:programacion_movil/features/presentation/pages/record_categories/widgets/individual/individual_game_card.dart';
import 'package:programacion_movil/features/presentation/pages/record_categories/widgets/team/team_game_card.dart';
import 'package:programacion_movil/features/presentation/pages/record_categories/widgets/shared/empty_state_widget.dart';
import 'package:programacion_movil/features/presentation/pages/record_categories/widgets/button/button_popup_delete.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _gameHistory = [];
  bool _isLoading = true;
  Map<String, dynamic>? _statistics;
  late TabController _tabController;

  // Listas separadas por modo
  List<Map<String, dynamic>> _individualGames = [];
  List<Map<String, dynamic>> _teamGames = [];
  List<Map<String, dynamic>> _rankings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    
    try {
      final history = await AppDatabase.instance.getGameHistory();
      final stats = await AppDatabase.instance.getStatistics();
      final rankings = await AppDatabase.instance.getPlayerRankings();
      _rankings = rankings;
      setState((){
        _gameHistory = history;
        _statistics = stats;
        
        // Separar juegos por modo
        _individualGames = history.where((game) => 
          game['game_mode'] != 'Team Mode'
        ).toList();
        
        _teamGames = history.where((game) => 
          game['game_mode'] == 'Team Mode'
        ).toList();
        
        _isLoading = false;
      });
      
      debugPrint('📊 Historial cargado: ${_gameHistory.length} partidas');
      debugPrint('   Individual: ${_individualGames.length}');
      debugPrint('   Equipos: ${_teamGames.length}');
    } catch (e) {
      debugPrint('❌ Error al cargar historial: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteGame(int gameId) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return ButtonPopupDelete(
          title: '¿Eliminar esta partida del historial?',
          onCorrect: () async {
            // Eliminar la partida
            await AppDatabase.instance.deleteGameHistory(gameId);
            _loadHistory();

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Partida eliminada'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          onReset: () {
            // No hacer nada, ButtonPopupDelete lo cierra automáticamente
          },
        );
      },
    );
  }

  Future<void> _clearAllHistory() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Borrar todo el historial'),
        content: const Text(
          '¿Estás seguro? Esta acción no se puede deshacer.',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Borrar todo',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AppDatabase.instance.clearAllHistory();
      _loadHistory();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todo el historial ha sido eliminado'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header con estadísticas
            RecordHeader(
              statistics: _statistics,
              hasGames: _gameHistory.isNotEmpty,
              onClearAll: _clearAllHistory,
            ),

            // TabBar
            RecordTabBar(
              controller: _tabController,
              individualCount: _individualGames.length,
              teamCount: _teamGames.length,
              playersCount: _rankings.length,
            ),

            // TabBarView con las listas
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        // Tab Individual
                        _buildGamesList(_individualGames, false),
                        // Tab Equipos
                        _buildGamesList(_teamGames, true),
                        RankingList(rankings: _rankings, onRefresh: _loadHistory)
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGamesList(List<Map<String, dynamic>> games, bool isTeamMode) {
    if (games.isEmpty) {
      return EmptyStateWidget(isTeamMode: isTeamMode);
    }

    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return isTeamMode 
              ? TeamGameCard(
                  game: game,
                  onDelete: () => _deleteGame(game['id']),
                )
              : IndividualGameCard(
                  game: game,
                  onDelete: () => _deleteGame(game['id']),
                );
        },
      ),
    );
  }
}