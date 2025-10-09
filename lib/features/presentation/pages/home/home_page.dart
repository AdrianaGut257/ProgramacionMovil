import 'package:flutter/material.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/home_header.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
  
    final size = MediaQuery.of(context).size;
    final height = size.height;
   
    // Escala de tamaño dinámico (para pantallas pequeñas)
    final isSmallScreen = height < 700;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeHeader(),
                      SizedBox(height: isSmallScreen ? 10 : 20),

                      // Espacio adaptable
                      SizedBox(height: height * 0.03),

                      // Botones principales
                      CustomButton(
                        text: "Modo fácil",
                        icon: Icons.person,
                        onPressed: () {
                          context.push('/modality-information-normal');
                        },
                      ),
                      SizedBox(height: isSmallScreen ? 10 : 20),

                      CustomButton(
                        text: "Modo difícil",
                        icon: Icons.person,
                        onPressed: () {
                          context.push('/modality-information-hard');
                        },
                      ),
                      SizedBox(height: isSmallScreen ? 10 : 20),

                      CustomButton(
                        text: "Modo grupal",
                        icon: Icons.group,
                        onPressed: () {
                          context.push('/modality-information-team');
                        },
                      ),
                      SizedBox(height: isSmallScreen ? 10 : 20),

                      CustomButton(
                        text: "Comodines",
                        icon: Icons.star,
                        onPressed: () {
                          context.push('/comodines-info');
                        },
                      ),
                      

                    
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
