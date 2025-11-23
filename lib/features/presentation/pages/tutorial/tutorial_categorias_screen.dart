import 'package:flutter/material.dart';
import 'package:programacion_movil/config/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class TutorialCategoriasScreen extends StatefulWidget {
  const TutorialCategoriasScreen({super.key});

  @override
  State<TutorialCategoriasScreen> createState() =>
      _TutorialCategoriasScreenState();
}

class _TutorialCategoriasScreenState extends State<TutorialCategoriasScreen> {
  int _currentStep = 0;
  final GlobalKey _inputFieldKey = GlobalKey();
  final GlobalKey _addButtonKey = GlobalKey();
  final GlobalKey _categoryListKey = GlobalKey();
  final GlobalKey _deleteButtonKey = GlobalKey();
  final GlobalKey _navbarKey = GlobalKey();
  final GlobalKey _navbarCategoriesKey = GlobalKey();
  final verticalOffset = 150.0;

  final List<TutorialStep> _steps = [
    TutorialStep(
      title: 'Paso 1: Navegación',
      description:
          'Toca el ícono de categorías en la barra inferior para ir a la pantalla de categorías',
      highlightKey: 'navbarCategories',
      showTextInField: '',
      addButtonEnabled: false,
      categories: [],
    ),
    TutorialStep(
      title: 'Paso 2: Campo de texto',
      description: 'Este es el campo donde escribes el nombre de tu categoría',
      highlightKey: 'input',
      showTextInField: '',
      addButtonEnabled: false,
      categories: [],
    ),
    TutorialStep(
      title: 'Paso 3: Escribe el nombre',
      description: 'Aquí puedes ver cómo se vería al escribir "Deportes"',
      highlightKey: 'input',
      showTextInField: 'Deportes',
      addButtonEnabled: true,
      categories: [],
    ),
    TutorialStep(
      title: 'Paso 4: Botón de agregar',
      description: 'Presiona este botón verde para crear la categoría',
      highlightKey: 'addButton',
      showTextInField: 'Deportes',
      addButtonEnabled: true,
      categories: [],
    ),
    TutorialStep(
      title: 'Paso 5: Categoría creada',
      description: '¡Así aparecerá tu nueva categoría en la lista!',
      highlightKey: 'categoryList',
      showTextInField: '',
      addButtonEnabled: false,
      categories: [
        {'name': 'Deportes', 'icon': Icons.sports_soccer},
      ],
    ),
    TutorialStep(
      title: 'Paso 6: Botón de eliminar',
      description: 'Usa este botón rojo para eliminar cualquier categoría',
      highlightKey: 'deleteButton',
      showTextInField: '',
      addButtonEnabled: false,
      categories: [
        {'name': 'Deportes', 'icon': Icons.sports_soccer},
      ],
    ),
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final currentStepData = _steps[_currentStep];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Tutorial',
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: _nextStep,
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 10),

                Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.6,
                    child: AspectRatio(
                      aspectRatio: 370 / 170,
                      child: Image.asset(
                        'assets/icons/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  "Categorías",
                  style: GoogleFonts.titanOne(
                    fontSize: width * 0.095,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    letterSpacing: 0,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                Text(
                  'Crea tu categoría',
                  style: GoogleFonts.titanOne().copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    letterSpacing: 0,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildStaticInputField(currentStepData),
                ),

                const SizedBox(height: 24),

                Text(
                  "Selecciona una categoría para eliminarla",
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.035,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),
                Expanded(child: _buildCategoryList(currentStepData)),

                const SizedBox(height: 130),
              ],
            ),
            Positioned(
              bottom: 110,
              left: 0,
              right: 0,
              child: _buildTutorialNavbar(),
            ),

            if (currentStepData.highlightKey != 'none')
              _buildHighlightOverlay(currentStepData),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildInstructionBanner(currentStepData),
            ),

            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: _buildNavigationBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialNavbar() {
    return Container(
      key: _navbarKey,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, false),
          _buildNavItem(Icons.category_outlined, true, isCenter: true),
          _buildNavItem(Icons.bar_chart, false),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    bool isSelected, {
    bool isCenter = false,
  }) {
    return Container(
      key: isCenter ? _navbarCategoriesKey : null,
      child: Icon(
        icon,
        size: 30,
        color: isSelected ? AppColors.secondary : AppColors.grey,
      ),
    );
  }

  Widget _buildInstructionBanner(TutorialStep step) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.secondaryVariant],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.secondary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step.title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentStep + 1}/${_steps.length}',
                  style: GoogleFonts.poppins(
                    color: AppColors.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.secondary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    step.description,
                    style: GoogleFonts.poppins(
                      color: AppColors.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaticInputField(TutorialStep step) {
    return Container(
      key: _inputFieldKey,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryVariant,
        borderRadius: BorderRadius.circular(25),
        border: Border(
          bottom: BorderSide(color: AppColors.primaryVariant, width: 4),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(25),
          border: Border(
            bottom: BorderSide(color: AppColors.primaryVariant, width: 3),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.category_outlined, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      step.showTextInField.isEmpty
                          ? 'Escribe aquí'
                          : step.showTextInField,
                      style: TextStyle(
                        color: step.showTextInField.isEmpty
                            ? const Color(0xFFB3C5D7)
                            : Colors.white,
                        fontSize: 20,
                        fontWeight: step.showTextInField.isEmpty
                            ? FontWeight.normal
                            : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              key: _addButtonKey,
              padding: const EdgeInsets.only(right: 9),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: step.addButtonEnabled
                      ? const Color(0xFF10B981)
                      : const Color(0xFF6EE7B7),
                  shape: BoxShape.circle,
                  boxShadow: step.addButtonEnabled
                      ? [
                          BoxShadow(
                            color: const Color(0xFF10B981),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(TutorialStep step) {
    if (step.categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 64,
              color: AppColors.grey.withValues(
                alpha: 0.5,
              ), // Agregar transparencia
            ),
            const SizedBox(height: 16),

            Text(
              "No hay categorías creadas",
              style: GoogleFonts.poppins(
                color: AppColors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      key: _categoryListKey,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: step.categories.length,
      itemBuilder: (context, index) {
        final category = step.categories[index];
        return _buildCategoryCard(
          category['name'] as String,
          category['icon'] as IconData,
        );
      },
    );
  }

  Widget _buildCategoryCard(String name, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary,
                    AppColors.primaryVariant,
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: AppColors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                  height: 1.2,
                ),
              ),
            ),
            Container(
              key: _deleteButtonKey,
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF87171),
                    Color(0xFFEF4444),
                    Color(0xFFDC2626),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF4444),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightOverlay(TutorialStep step) {
    return IgnorePointer(
      child: CustomPaint(
        painter: SpotlightPainter(
          highlightKey: step.highlightKey,
          inputFieldKey: _inputFieldKey,
          addButtonKey: _addButtonKey,
          categoryListKey: _categoryListKey,
          deleteButtonKey: _deleteButtonKey,
          navbarCategoriesKey: _navbarCategoriesKey,
        ),
        child: Container(),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            ElevatedButton.icon(
              onPressed: _previousStep,
              icon: const Icon(Icons.arrow_back, size: 20),
              label: const Text('Atrás'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.grey,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            )
          else
            const SizedBox(width: 90),

          Row(
            children: List.generate(_steps.length > 3 ? 3 : _steps.length, (
              index,
            ) {
              int displayStep;
              if (_steps.length <= 3) {
                displayStep = index;
              } else if (_currentStep == 0) {
                displayStep = index;
              } else if (_currentStep == _steps.length - 1) {
                displayStep = _steps.length - 3 + index;
              } else {
                displayStep = _currentStep - 1 + index;
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: displayStep == _currentStep ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: displayStep == _currentStep
                      ? AppColors.primary
                      : AppColors.grey,
                ),
              );
            }),
          ),

          ElevatedButton.icon(
            onPressed: _nextStep,
            label: Text(
              _currentStep == _steps.length - 1 ? 'Finalizar' : 'Siguiente',
            ),
            icon: Icon(
              _currentStep == _steps.length - 1
                  ? Icons.check_circle
                  : Icons.arrow_forward,
              size: 20,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialStep {
  final String title;
  final String description;
  final String highlightKey;
  final String showTextInField;
  final bool addButtonEnabled;
  final List<Map<String, dynamic>> categories;

  TutorialStep({
    required this.title,
    required this.description,
    required this.highlightKey,
    required this.showTextInField,
    required this.addButtonEnabled,
    required this.categories,
  });
}

class SpotlightPainter extends CustomPainter {
  final String highlightKey;
  final GlobalKey inputFieldKey;
  final GlobalKey addButtonKey;
  final GlobalKey categoryListKey;
  final GlobalKey deleteButtonKey;
  final GlobalKey navbarCategoriesKey;

  SpotlightPainter({
    required this.highlightKey,
    required this.inputFieldKey,
    required this.addButtonKey,
    required this.categoryListKey,
    required this.deleteButtonKey,
    required this.navbarCategoriesKey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    RRect? highlightRect;

    switch (highlightKey) {
      case 'input':
        highlightRect = _getHighlightRect(inputFieldKey, padding: 8);
        break;
      case 'addButton':
        highlightRect = _getHighlightRect(addButtonKey, padding: 12);
        break;
      case 'categoryList':
        highlightRect = _getHighlightRect(categoryListKey, padding: 16);
        if (highlightRect != null) {
          highlightRect = RRect.fromRectAndRadius(
            Rect.fromLTWH(
              highlightRect.left,
              highlightRect.top - 30,
              highlightRect.width,
              highlightRect.height - 100,
            ),
            highlightRect.tlRadius,
          );
        }
        break;
      case 'navbarCategories':
        highlightRect = _getHighlightRect(navbarCategoriesKey, padding: 17);
        break;
      case 'deleteButton':
        highlightRect = _getHighlightRect(deleteButtonKey, padding: 12);
        break;
    }

    if (highlightRect != null) {
      final path = Path()
        ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
        ..addRRect(highlightRect)
        ..fillType = PathFillType.evenOdd;
      final darkOverlay = Paint()
        ..color = const Color(0x99000000)
        ..style = PaintingStyle.fill;

      canvas.drawPath(path, darkOverlay);

      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawRRect(highlightRect, borderPaint);

      final innerBorderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawRRect(highlightRect, innerBorderPaint);
    }
  }

  RRect? _getHighlightRect(GlobalKey key, {double padding = 8}) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return null;

    try {
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;

      return RRect.fromRectAndRadius(
        Rect.fromLTWH(
          position.dx - padding,
          position.dy - padding - 90,
          size.width + (padding * 2),
          size.height + (padding * 2),
        ),
        const Radius.circular(25),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
