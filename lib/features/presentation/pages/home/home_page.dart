import 'package:flutter/material.dart';
import '../../widgets/buttons/custom_button.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;

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
                      //aca animacion!!!
                        SizedBox(height: 20),
Center(
  child: FractionallySizedBox(
    widthFactor: 0.9, 
    child: AspectRatio(
      aspectRatio: 370 / 170, 
      child: Image.asset(
        'assets/icons/logo.png',
        fit: BoxFit.contain, 
      ),
    ),
  ),
),

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
