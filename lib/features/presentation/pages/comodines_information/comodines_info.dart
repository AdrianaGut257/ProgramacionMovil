import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/widgets/modality_information.dart';
import '../../widgets/buttons/custom_button.dart';
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
              ? "✅ Comodines activados para este juego"
              : "❌ Comodines desactivados",
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Botón volver arriba a la izquierda
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () {
                    context.pop(); // Vuelve a la pantalla anterior
                  },
                ),
              ),

              Text(
                "Tipos de comodines",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                "Los comodines aparecen aleatoriamente en el tablero del juego, solo tienes que apretar el botón que aparece.",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Las tarjetas se adaptan al contenido
              StatsCards(
                timeIcon: Icons.access_time,
                timeTitle: 'Tiempo extra',
                timeValue:
                    'Podrá tener 5 segundos extras para decir la palabra.',
                levelIcon: Icons.star_half,
                levelTitle: 'Saltar turno',
                levelValue:
                    'Permite saltar el turno e ir hacia la siguiente persona.',
                cardColor: AppColors.primary,
              ),

              const SizedBox(height: 12),

              StatsCards(
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

              const SizedBox(height: 20),

              // Botón de comodines
              CustomButton(
                text: _powerUpsEnabled
                    ? "Comodines activados"
                    : "Comodines desactivados",
                icon: Icons.extension,
                backgroundColor:
                    _powerUpsEnabled ? Colors.yellow[700] : Colors.grey[600],
                textColor: Colors.white,
                onPressed: _togglePowerUps,
              ),

              const SizedBox(height: 15),

              // Botón jugar
              CustomButton(
                text: "Jugar",
                icon: Icons.group,
                onPressed: () {
                  context.push('/player-register');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
