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
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final isSmallScreen = height < 700;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      // Encabezado
                      HomeHeader(onBackPressed: () => context.pop()),

                      SizedBox(height: isSmallScreen ? 8 : 16),

                      // Título
                      Text(
                        "Tipos de Comodines",
                        style: TextStyle(
                          fontSize: width * 0.045, // tamaño relativo
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: isSmallScreen ? 4 : 8),

                      // Descripción
                      Text(
                        "Los comodines aparecen aleatoriamente en el tablero del juego, solo tienes que apretar el botón que aparece.",
                        style: TextStyle(
                          fontSize: width * 0.035,
                          color: const Color.fromARGB(96, 0, 0, 0),
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: isSmallScreen ? 10 : 16),

                      // Contenido de las tarjetas
                      ComodinCards(
                        leftAssetPath: 'assets/icons/gestion-del-tiempo.png',
                        leftTitle: 'Tiempo extra',
                        leftValue:
                            'Podrá tener 5 segundos extras para decir la palabra.',
                        rightAssetPath: 'assets/icons/espada.png',
                        rightTitle: 'Saltar turno',
                        rightValue:
                            'Permite saltar el turno e ir directamente hacia la siguiente persona.',
                        cardColor: const Color.fromRGBO(97, 90, 199, 1),
                      ),

                      SizedBox(height: isSmallScreen ? 10 : 15),

                      ComodinCards(
                        leftAssetPath: 'assets/icons/apuesta.png',
                        leftTitle: 'Punto doble',
                        leftValue:
                            'Podrá activar el doble de la puntuación al decir la palabra.',
                        rightAssetPath: 'assets/icons/prision.png',
                        rightTitle: 'Castigo leve',
                        rightValue:
                            'Se elige 1 letra y las demás se bloquean para la próxima persona.',
                        cardColor: const Color.fromRGBO(97, 90, 199, 1),
                      ),

                      SizedBox(height: isSmallScreen ? 12 : 20),

                      // Botones
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

                      SizedBox(height: isSmallScreen ? 8 : 12),

                      CustomButton(
                        text: "Jugar",
                        icon: Icons.group,
                        backgroundColor: AppColors.secondary,
                        textColor: Colors.white,
                        onPressed: () {
                          context.push('/player-register');
                        },
                      ),

                      SizedBox(height: height * 0.05), // margen inferior adaptable
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
