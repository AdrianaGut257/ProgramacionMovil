import 'package:flutter/material.dart';

class Ranking extends StatelessWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StopWordsWinnersScreen(),
    );
  }
}

class StopWordsWinnersScreen extends StatefulWidget {
  const StopWordsWinnersScreen({Key? key}) : super(key: key);

  @override
  State<StopWordsWinnersScreen> createState() => _StopWordsWinnersScreenState();
}

class _StopWordsWinnersScreenState extends State<StopWordsWinnersScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _podiumController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController =
        AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _slideController =
        AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _podiumController =
        AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () => _slideController.forward());
    Future.delayed(const Duration(milliseconds: 400), () => _podiumController.forward());
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _podiumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05,
              vertical: size.height * 0.02,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'StopWords',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.width * 0.1,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFFFA726),
                          shadows: const [
                            Shadow(
                              offset: Offset(3, 3),
                              blurRadius: 6,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'WINNERS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.width * 0.09,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFE040FB),
                          shadows: const [
                            Shadow(
                              offset: Offset(3, 3),
                              blurRadius: 6,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                // Podio
                AnimatedBuilder(
                  animation: _podiumController,
                  builder: (context, child) {
                    final scaleFactor =
                        isSmallScreen ? 0.85 : 1.0; // reduce podio en pantallas pequeñas
                    return Transform.scale(
                      scale: scaleFactor,
                      child: SizedBox(
                        height: size.height * 0.25,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: _buildPodiumPlace(
                                name: 'Dina',
                                score: '16',
                                position: '2',
                                height: size.height * 0.12 * _podiumController.value,
                                color: const Color(0xFF7C4DFF),
                                size: size,
                              ),
                            ),
                            SizedBox(width: size.width * 0.02),
                            Expanded(
                              child: _buildPodiumPlace(
                                name: 'Dayana',
                                score: '17',
                                position: '1',
                                height: size.height * 0.18 * _podiumController.value,
                                color: const Color(0xFF7C4DFF),
                                isWinner: true,
                                size: size,
                              ),
                            ),
                            SizedBox(width: size.width * 0.02),
                            Expanded(
                              child: _buildPodiumPlace(
                                name: 'Juan',
                                score: '5',
                                position: '3',
                                height: size.height * 0.09 * _podiumController.value,
                                color: const Color(0xFF7C4DFF),
                                size: size,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: size.height * 0.04),

                // Lista de rankings
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        _buildRankingItem(1, 'Dayana', 17, const Color(0xFF7C4DFF), size, 0),
                        SizedBox(height: size.height * 0.012),
                        _buildRankingItem(2, 'Dina', 16, const Color(0xFF9575CD), size, 100),
                        SizedBox(height: size.height * 0.012),
                        _buildRankingItem(3, 'Juan', 5, const Color(0xFFBA68C8), size, 200),
                        SizedBox(height: size.height * 0.012),
                        _buildRankingItem(4, 'Carlos', 2, const Color(0xFFCE93D8), size, 300),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.05),

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: _buildButton(
                        context: context,
                        label: 'Jugar',
                        icon: Icons.videogame_asset,
                        color: const Color(0xFF26C6DA),
                        size: size,
                      ),
                    ),
                    SizedBox(width: size.width * 0.03),
                    Expanded(
                      child: _buildButton(
                        context: context,
                        label: 'Salir',
                        color: const Color(0xFFEC407A),
                        size: size,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Métodos auxiliares (sin cambios visuales, solo tamaños más flexibles)

  Widget _buildPodiumPlace({
    required String name,
    required String score,
    required String position,
    required double height,
    required Color color,
    required Size size,
    bool isWinner = false,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.85 + (0.15 * value),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA726),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  score,
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: height.clamp(40, 160),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color, color.withOpacity(0.8)],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Text(
                    position,
                    style: TextStyle(
                      fontSize: isWinner ? size.width * 0.1 : size.width * 0.085,
                      fontWeight: FontWeight.w900,
                      color: isWinner ? const Color(0xFF26C6DA) : Colors.white,
                      shadows: const [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 4,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRankingItem(
      int position, String name, int score, Color color, Size size, int delay) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: size.height * 0.014,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: size.width * 0.045,
                    child: Text(
                      '$position',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w900,
                        fontSize: size.width * 0.045,
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.04),
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.045,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '$score',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    IconData? icon,
    required Color color,
    required Size size,
  }) {
    return ElevatedButton(
      onPressed: () => Navigator.pop(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: size.height * 0.018),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
      ),
      child: icon != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: size.width * 0.048,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                Icon(icon, color: Colors.white, size: size.width * 0.06),
              ],
            )
          : Text(
              label,
              style: TextStyle(
                fontSize: size.width * 0.048,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    );
  }
}
