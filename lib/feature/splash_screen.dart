import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/feature/constants/app_colors.dart';
import 'package:flutter_project/feature/shared/navigation/app_router.gr.dart';

@RoutePage()
class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with TickerProviderStateMixin {
  late AnimationController _dividerController;
  late Animation<double> _dividerAnimation;

  @override
  void initState() {
    super.initState();

    // Divider animation - smooth left (0.0) to right (1.0) movement with reverse
    _dividerController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 3000,
      ), // 3 seconds for one direction
    );
    _dividerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _dividerController, curve: Curves.easeInOut),
    );

    // Start divider animation - repeat continuously (left to right, then right to left)
    _dividerController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _dividerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Image section with before/after comparison
                Container(
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        // Base image (static, always visible and clean - never moves)
                        Positioned.fill(
                          child: Image.asset(
                            'assets/backgrounds/splash_screen_image.png',
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade300,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Image not found',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        // Animated divider with before/after comparison
                        AnimatedBuilder(
                          animation: _dividerAnimation,
                          builder: (context, child) {
                            final screenWidth =
                                MediaQuery.of(context).size.width - 48;
                            final dividerValue = _dividerAnimation.value;
                            final dividerPosition = screenWidth * dividerValue;

                            // Left side (before): Base image shows original with full background
                            // Right side (after): Checkerboard overlay shows transparency where background is removed

                            return IgnorePointer(
                              child: Stack(
                                children: [
                                  // Right side overlay - Transparent checkerboard (after/bg removed)
                                  // This shows the "after" state with background removed
                                  if (dividerValue >
                                      0) // Only show when divider has moved from left
                                    Positioned.fill(
                                      child: ClipRect(
                                        clipper: _RightSideClipper(
                                          dividerPosition,
                                        ),
                                        child: Stack(
                                          children: [
                                            // Checkerboard background pattern
                                            Positioned.fill(
                                              child: CustomPaint(
                                                painter: CheckerboardPainter(),
                                              ),
                                            ),
                                            // Image overlay on top of checkerboard
                                            Positioned.fill(
                                              child: Opacity(
                                                opacity: 0.7,
                                                child: Image.asset(
                                                  'assets/backgrounds/splash_screen_image.png',
                                                  fit: BoxFit.contain,
                                                  alignment: Alignment.center,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Container(
                                                          color: Colors
                                                              .grey
                                                              .shade300,
                                                        );
                                                      },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  // Moving divider line with arrows
                                  Positioned(
                                    left: dividerPosition - 15,
                                    top: 0,
                                    bottom: 0,
                                    width: 30,
                                    child: Stack(
                                      children: [
                                        // Divider line
                                        Positioned(
                                          left: 14,
                                          top: 0,
                                          bottom: 0,
                                          width: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Left arrow
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Center(
                                            child: Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.9,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.chevron_left,
                                                color: Colors.grey.shade600,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Right arrow
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Center(
                                            child: Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.9,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.chevron_right,
                                                color: Colors.grey.shade600,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        // Circular red button with sparkle icons at bottom right
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.primaryCoral,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryCoral.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Two sparkle icons
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  child: Icon(
                                    Icons.auto_awesome,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  right: 12,
                                  child: Icon(
                                    Icons.auto_awesome,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Text section - matching image layout
                Column(
                  children: [
                    const Text(
                      'Start with Image',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Background Remover',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryCoral,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Remove background from image instantly,\nfully automated and Free',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // Get Started Button - large rounded red button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      // Stop animation before navigation
                      _dividerController.stop();
                      context.router.replace(const TutorialRoute());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryCoral,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RightSideClipper extends CustomClipper<Rect> {
  final double dividerPosition;

  _RightSideClipper(this.dividerPosition);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(dividerPosition, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(_RightSideClipper oldClipper) {
    return oldClipper.dividerPosition != dividerPosition;
  }
}

class CheckerboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double squareSize = 10;
    final paint1 = Paint()..color = Colors.white;
    final paint2 = Paint()..color = Colors.grey.shade200;

    for (double i = 0; i < size.height; i += squareSize) {
      for (double j = 0; j < size.width; j += squareSize) {
        final isEven = ((i / squareSize) + (j / squareSize)) % 2 == 0;
        canvas.drawRect(
          Rect.fromLTWH(j, i, squareSize, squareSize),
          isEven ? paint1 : paint2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
