import 'package:go_router/go_router.dart';
import 'package:programacion_movil/features/presentation/pages/comodines_information/comodines_info.dart';
import 'package:programacion_movil/features/presentation/pages/categorias_information/categorias_info.dart';
import 'package:programacion_movil/features/presentation/pages/selected_modality/selected_modality.dart';
import 'package:programacion_movil/features/presentation/pages/home/home_principal.dart';
import 'package:programacion_movil/features/presentation/widgets/category/category.dart';
import 'package:programacion_movil/features/presentation/pages/register_names/individual_mode/players_register_page.dart';

import '../features/presentation/pages/register_names/group_mode/group_mode_page.dart';
import '../features/presentation/pages/modality_information/hard_mode.dart';
import '../features/presentation/pages/modality_information/easy_mode.dart';
import '../features/presentation/pages/modality_information/team_mode.dart';
import '../features/presentation/pages/game_board/board_team_mode/board_team_mode.dart';
import '../features/presentation/pages/game_board/board_individual_mode/board_easy_mode.dart';
import '../features/presentation/pages/game_board/board_individual_mode/board_hard_mode.dart';
import '../features/presentation/pages/record_game/record.dart';

import '../features/presentation/widgets/navigation_bar.dart';
import 'package:programacion_movil/features/presentation/pages/tutorial/tutorial_button.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Stack(
            children: [
              child,

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: const CustomNavigationBar(),
              ),

              const TutorialButton(),
            ],
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeStopWords(),
          ),

          GoRoute(path: '/mode', builder: (context, state) => const HomePage()),

          GoRoute(
            path: '/record',
            builder: (context, state) => const RecordPage(),
          ),

          GoRoute(
            path: '/group-mode',
            builder: (context, state) => const GroupModePage(),
          ),

          GoRoute(
            path: '/player-register',
            builder: (context, state) {
              final extras = state.extra as Map<String, dynamic>?;
              return PlayersRegisterScreen(
                difficulty: extras?['difficulty'] as String?,
              );
            },
          ),
          GoRoute(
            path: '/select-categories',
            builder: (context, state) {
              final extras = state.extra as Map<String, dynamic>?;
              return Category(
                mode: extras?['mode'],
                players: extras?['players'],
                difficulty: extras?['difficulty'],
              );
            },
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
            path: '/board-game',
            builder: (context, state) => const BoardTeamModePage(),
          ),
          GoRoute(
            path: '/board-game-easy',
            builder: (context, state) => const BoardEasyModePage(),
          ),
          GoRoute(
            path: '/board-game-hard',
            builder: (context, state) => const BoardHardModePage(),
          ),
          GoRoute(
            path: '/comodines-info',
            builder: (context, state) => const ComodinesPage(),
          ),
          GoRoute(
            path: '/categorias-info',
            builder: (context, state) => const CategoriasPage(),
          ),
        ],
      ),
    ],
  );
}
