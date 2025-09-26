import 'package:go_router/go_router.dart';
import 'package:programacion_movil/features/presentation/pages/board/board_page.dart';
import 'package:programacion_movil/features/presentation/pages/category/category.dart';
import 'package:programacion_movil/features/presentation/pages/individual_mode/widgets/players_register_screen.dart';
import 'package:programacion_movil/features/presentation/pages/game_start/easy_game_page.dart';
import '../features/presentation/pages/home/home_page.dart';
import '../features/presentation/pages/group_mode/group_mode_page.dart';
import '../features/presentation/pages/modality_selection/modality_selection_page.dart';
import '../features/presentation/pages/modality_information/hard_mode.dart';
import '../features/presentation/pages/modality_information/easy_mode.dart';
import '../features/presentation/pages/modality_information/team_mode.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/group-mode',
        builder: (context, state) => const GroupModePage(),
      ),
      GoRoute(
        path: '/player-register',
        builder: (context, state) => const PlayersRegisterScreen(),
      ),
      GoRoute(
        path: '/board-game',
        builder: (context, state) => const BoardPage(),
      ),
      GoRoute(
        path: '/select-categories',
        builder: (context, state) => const Category(),
      ),
      GoRoute(
        path: '/modality-selection',
        builder: (context, state) => const ModalitySelectionPage(),
      ),
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
            // compatibilidad si llega una lista de jugadores directamente
            players = extra.cast<String>();
          }

          return EasyGamePage(
            players: players,
            categories: categories,
            startAsEasy: true, // 10s
          );
        },
      ),

      // 🔥 Modo DIFÍCIL: 5 segundos
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
    ],
  );
}


