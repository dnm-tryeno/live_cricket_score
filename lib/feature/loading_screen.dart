import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/data/local/shared_pref/my_shared_preferences.dart';
import 'package:flutter_project/feature/constants/app_colors.dart';
import 'package:flutter_project/feature/shared/navigation/app_router.gr.dart';

@RoutePage()
class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _dividerController;
  late Animation<double> _progressAnimation;
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

    // Progress animation - starts immediately and runs in parallel
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6), // Total loading time
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start divider animation - repeat continuously (left to right, then right to left)
    _dividerController.repeat(reverse: true);

    // Start progress animation
    _animationController.forward();

    // Navigate to splash screen or home based on tutorial completion
    Future.delayed(const Duration(seconds: 2), () async {
      if (mounted) {
        _dividerController.stop(); // Stop the loop before navigation

        // Check if tutorial has been completed
        final tutorialCompleted = await SharedPrefManager.isTutorialCompleted();

        if (tutorialCompleted) {
          // Skip tutorial and go directly to home
          context.router.replace(const HomeRoute());
        } else {
          // Show splash screen which leads to tutorial
          context.router.replace(const SplashScreenRoute());
        }
      }
    });
  }

  @override
  void dispose() {
    _dividerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
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
                        // Left side navigation arrows
                        Positioned(
                          left: 16,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chevron_left,
                                    color: Colors.grey.shade400,
                                    size: 20,
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey.shade400,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Text section
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

                // Loading indicator
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.grey.shade200,
                      ),
                      child: Stack(
                        children: [
                          // Progress bar - only starts after divider animation
                          AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) {
                              return FractionallySizedBox(
                                widthFactor: _progressAnimation.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primaryCoral,
                                        Colors.pink.shade200,
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Loading, please wait...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
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
