import 'package:go_router/go_router.dart';
import 'package:programacion_movil/features/presentation/pages/category/category.dart';
import 'package:programacion_movil/features/presentation/pages/individual_mode/widgets/players_register_screen.dart';
import '../features/presentation/pages/home/home_page.dart';
import '../features/presentation/pages/group_mode/group_mode_page.dart';

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
    ],
  );
}
