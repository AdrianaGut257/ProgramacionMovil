import 'package:go_router/go_router.dart';
import 'package:programacion_movil/features/presentation/widgets/game/board/board_page.dart';
import 'package:programacion_movil/features/presentation/pages/category/category.dart';
import 'package:programacion_movil/features/presentation/pages/register_names/individual_mode/players_register_page.dart';
import '../features/presentation/pages/home/home_page.dart';
import '../features/presentation/pages/register_names/group_mode/group_mode_page.dart';
import '../features/presentation/pages/modality_selection/modality_selection_page.dart';
import '../features/presentation/pages/modality_information/hard_mode.dart';
import '../features/presentation/pages/modality_information/easy_mode.dart';
import '../features/presentation/pages/modality_information/team_mode.dart';
import '../features/presentation/pages/game_board/board_team_mode/board_team_mode.dart';

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
      GoRoute(
        path: '/board-gamee',
        builder: (context, state) => const BoardTeamModePage(),
      ),
    ],
  );
}
