import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:programacion_movil/features/presentation/pages/home/widgets/animated_background.dart';
import 'package:programacion_movil/features/presentation/pages/home/widgets/info_modal.dart';
import 'package:programacion_movil/features/presentation/widgets/buttons/custom_button.dart';
import 'package:programacion_movil/features/presentation/pages/tutorial/tutorial_tooltip.dart';

class HomeStopWords extends StatefulWidget {
  const HomeStopWords({super.key});

  @override
  State<HomeStopWords> createState() => _HomeStopWordsState();
}

class _HomeStopWordsState extends State<HomeStopWords>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _showTooltip = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    _checkIfShouldShowTooltip();
  }

  Future<void> _checkIfShouldShowTooltip() async {
    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      setState(() {
        _showTooltip = true;
      });
    }
  }

  void _dismissTooltip() {
    if (mounted) {
      setState(() {
        _showTooltip = false;
      });
    }
  }

  void _openTutorial() {
    context.push('/tutorial-categorias');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryVariant, AppColors.primary],
              ),
            ),
          ),

          const AnimatedBackground(),

          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'logo',
                          child: Image.asset(
                            'assets/icons/logo.png',
                            width: isSmallScreen ? 330 : 420,
                          ),
                        ),

                        SizedBox(height: isSmallScreen ? 45 : 65),

                        _buildPlayButton(isSmallScreen),

                        SizedBox(height: isSmallScreen ? 30 : 42),

                        _buildInfoButtons(context, isSmallScreen),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (_showTooltip)
            TutorialTooltip(
              onDismiss: _dismissTooltip,
              onOpenTutorial: _openTutorial,
            ),
        ],
      ),
    );
  }

  Widget _buildPlayButton(bool isSmallScreen) {
    return SizedBox(
      width: isSmallScreen ? 220 : 260,
      child: CustomButton(
        text: "Jugar",
        icon: Icons.play_arrow_rounded,
        fontSize: isSmallScreen ? 20 : 23,
        onPressed: () {
          context.push('/mode');
        },
      ),
    );
  }

  Widget _buildInfoButtons(BuildContext context, bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _infoButton(
          context,
          title: "Cómo jugar",
          icon: Icons.lightbulb_outline_rounded,
          color: AppColors.secondary,
          isSmallScreen: isSmallScreen,
          showComoJugar: true,
        ),
        const SizedBox(width: 15),
        _infoButton(
          context,
          title: "Reglas",
          icon: Icons.rule_rounded,
          color: AppColors.secondary,
          isSmallScreen: isSmallScreen,
          showComoJugar: false,
        ),
      ],
    );
  }

  Widget _infoButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required bool isSmallScreen,
    required bool showComoJugar,
  }) {
    final double paddingH = isSmallScreen ? 20 : 26;
    final double paddingV = isSmallScreen ? 11 : 14;

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      color: Colors.transparent,
      child: InkWell(
        onTap: () => InfoModal.show(
          context,
          title: title,
          icon: icon,
          color: color,
          showComoJugar: showComoJugar,
        ),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: paddingH,
            vertical: paddingV,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.secondary, Color(0xBF4A90E2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x594A90E2),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.white, size: isSmallScreen ? 18 : 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14.5 : 16.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
