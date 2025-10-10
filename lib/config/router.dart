import 'package:go_router/go_router.dart';
import 'package:programacion_movil/features/presentation/pages/board/board_page.dart';
import 'package:programacion_movil/features/presentation/pages/category/category.dart';
import 'package:programacion_movil/features/presentation/pages/individual_mode/widgets/players_register_screen.dart';
import 'package:programacion_movil/features/presentation/pages/game_start/easy_game_page.dart';
import 'package:programacion_movil/features/presentation/pages/game_start/final_ranking_page.dart';
import '../features/presentation/pages/home/home_page.dart';
import '../features/presentation/pages/group_mode/group_mode_page.dart';
import '../features/presentation/pages/modality_selection/modality_selection_page.dart';
import '../features/presentation/pages/modality_information/hard_mode.dart';
import '../features/presentation/pages/modality_information/easy_mode.dart';
import '../features/presentation/pages/modality_information/team_mode.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      // Página principal
      GoRoute(path: '/', builder: (context, state) => const HomePage()),

      // Modo grupal
      GoRoute(
        path: '/group-mode',
        builder: (context, state) => const GroupModePage(),
      ),

      // Registro de jugadores individuales
      GoRoute(
        path: '/player-register',
        builder: (context, state) => const PlayersRegisterScreen(),
      ),

      // Tablero general
      GoRoute(
        path: '/board-game',
        builder: (context, state) => const BoardPage(),
      ),

      // Selección de categorías
      GoRoute(
        path: '/select-categories',
        builder: (context, state) => const Category(),
      ),

      // Selección de modalidad
      GoRoute(
        path: '/modality-selection',
        builder: (context, state) => const ModalitySelectionPage(),
      ),

      // Información de modalidades
      GoRoute(
        path: '/modality-information-hard',
        builder: (context, state) => const HardModePage(),
      ),
      GoRoute(
        path: '/modality-information-normal',
        builder: (context, state) => const EasyMode(),
      ),
      GoRoute(
        path: '/modality-information-team',
        builder: (context, state) => const TeamModePage(),
      ),

      // 🚀 Modo FÁCIL: 10 segundos
      GoRoute(
        path: '/play-easy',
        builder: (context, state) {
          final extra = state.extra;
          List<String>? players;
          List<String>? categories;

          if (extra is Map) {
            players = (extra['players'] as List?)?.cast<String>();
            categories = (extra['categories'] as List?)?.cast<String>();
          } else if (extra is List) {
            players = extra.cast<String>();
          }

          return EasyGamePage(
            players: players,
            categories: categories,
            startAsEasy: true, // 10s
          );
        },
      ),

      // 🚀 Modo DIFÍCIL: 5 segundos
      GoRoute(
        path: '/play-hard',
        builder: (context, state) {
          final extra = state.extra;
          List<String>? players;
          List<String>? categories;

          if (extra is Map) {
            players = (extra['players'] as List?)?.cast<String>();
            categories = (extra['categories'] as List?)?.cast<String>();
          } else if (extra is List) {
            players = extra.cast<String>();
          }

          return EasyGamePage(
            players: players,
            categories: categories,
            startAsEasy: false, // 5s
          );
        },
      ),

      // 🏆 Pantalla de Ranking Final
      GoRoute(
        path: '/final-ranking',
        builder: (context, state) {
          final args = (state.extra as Map?) ?? {};
          final players = (args['players'] as List?)?.cast<String>() ?? const <String>[];
          final scores = (args['scores'] as List?)?.cast<int>() ?? const <int>[];
          return FinalRankingPage(players: players, scores: scores);
        },
      ),
    ],
  );
}
