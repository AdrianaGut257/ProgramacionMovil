import 'package:go_router/go_router.dart';
import 'package:programacion_movil/features/presentation/pages/category/category.dart';
import 'package:programacion_movil/features/presentation/pages/individual_mode/widgets/players_register_screen.dart';
import '../features/presentation/pages/home/home_page.dart';
import '../features/presentation/pages/group_mode/group_mode_page.dart';
import '../features/presentation/pages/modality_selection/modality_selection_page.dart';
import '../features/presentation/pages/modality_information/hard_mode.dart';
import '../features/presentation/pages/modality_information/normal_mode.dart';
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
        builder: (context, state) => const NormalModePage(),
      ),
      GoRoute(
        path: '/modality-information-team',
        builder: (context, state) => const TeamModePage(),
      ),
    ],
  );
}
