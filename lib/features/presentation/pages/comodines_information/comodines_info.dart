import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/widgets/modality_information.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/home_header.dart';
import 'package:go_router/go_router.dart';

class ComodinesPage extends StatefulWidget {
  const ComodinesPage({super.key});

  @override
  State<ComodinesPage> createState() => _ComodinesPageState();
}

class _ComodinesPageState extends State<ComodinesPage> {
  bool _powerUpsEnabled = false;

  void _togglePowerUps() {
    setState(() {
      _powerUpsEnabled = !_powerUpsEnabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _powerUpsEnabled
              ? "Comodines activados para este juego"
              : "Comodines desactivados",
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            HomeHeader(
              title: 'StopWords',
              onBackPressed: () {
                context.pop();
              },
            ),

            // Contenido
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      "Tipos de Comodines",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Los comodines aparecen aleatoriamente en el tablero del juego, solo tienes que apretar el botón que aparece.",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(96, 0, 0, 0),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Expanded(
                            child: StatsCards(
                              timeIcon: Icons.access_time,
                              timeTitle: 'Tiempo extra',
                              timeValue:
                                  'Podrá tener 5 segundos extras para decir la palabra.',
                              levelIcon: Icons.star_half,
                              levelTitle: 'Saltar turno',
                              levelValue:
                                  'Permite saltar el turno e ir hacia la siguiente persona.',
                              cardColor: const Color.fromRGBO(97, 90, 199, 1),
                            ),
                          ),

                          const SizedBox(height: 15),

                          Expanded(
                            child: StatsCards(
                              timeIcon: Icons.bolt,
                              timeTitle: 'Punto doble',
                              timeValue:
                                  'Podrá activar el doble de la puntuación al decir la palabra.',
                              levelIcon: Icons.block,
                              levelTitle: 'Castigo leve',
                              levelValue:
                                  'Se elige 1 letra y las demás se bloquean para la próxima persona.',
                              cardColor: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Column(
                      children: [
                        CustomButton(
                          text: _powerUpsEnabled
                              ? "Comodines activados"
                              : "Comodines desactivados",
                          icon: Icons.extension,
                          backgroundColor: _powerUpsEnabled
                              ? Colors.yellow[700]
                              : Colors.grey[600],
                          textColor: Colors.white,
                          onPressed: _togglePowerUps,
                        ),

                        const SizedBox(height: 8),

                        CustomButton(
                          text: "Jugar",
                          icon: Icons.group,
                          backgroundColor: AppColors.secondary,
                          textColor: Colors.white,
                          onPressed: () {
                            context.push('/player-register');
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
