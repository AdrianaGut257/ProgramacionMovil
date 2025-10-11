import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/colors.dart';

class HomeHeader extends StatefulWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const HomeHeader({super.key, this.title = 'StopWords', this.onBackPressed});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.bounceOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _slideController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtener tamaño de pantalla
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    // Escalar tamaño de fuente según el ancho
    final double responsiveFontSize = (width * 0.1).clamp(
      28.0,
      48.0,
    ); // Mínimo 28, máximo 48

    // Reducir márgenes en pantallas pequeñas
    final bool isSmallScreen = height < 700;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 10 : 20,
        horizontal: 20,
      ),
      child: Column(
        children: [
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (widget.onBackPressed != null)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: widget.onBackPressed,
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                        tooltip: 'Volver',
                        color: AppColors.textPrimary,
                        splashRadius: 24,
                      ),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: isSmallScreen ? 20 : 40),

          // Título animado
          ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.08,
                        vertical: height * 0.025,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Colors.white],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.textPrimary,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: AppColors.textPrimary.withOpacity(0.6),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              AppColors.textPrimary,
                              AppColors.textPrimary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Text(
                            widget.title,
                            style: GoogleFonts.blackOpsOne().copyWith(
                              fontSize: responsiveFontSize,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -1.5,
                              height: 1.1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 10 : 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
