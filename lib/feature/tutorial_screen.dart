import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/data/local/shared_pref/my_shared_preferences.dart';
import 'package:flutter_project/feature/constants/app_colors.dart';
import 'package:flutter_project/feature/shared/navigation/app_router.gr.dart';
import 'package:flutter_project/feature/shared/services/app_update_service.dart';

@RoutePage()
class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<TutorialItem> _tutorialPages = [
    TutorialItem(
      imagePath:
          'assets/backgrounds/Gemini_Generated_Image_6chg16chg16chg16.png',
      title: 'Remove Background',
      description:
          'Instantly remove backgrounds and create stunning images instantly with just one tap!.',
    ),
    TutorialItem(
      imagePath:
          'assets/backgrounds/Gemini_Generated_Image_br337lbr337lbr33.png',
      title: 'Easy to Use',
      description:
          'Simply select an image and watch the magic happen. Our AI automatically detects and removes backgrounds in seconds.',
    ),
    TutorialItem(
      imagePath:
          'assets/backgrounds/Gemini_Generated_Image_br337lbr337lbr33.png',
      title: 'Free & Unlimited',
      description:
          'Process unlimited images for free. No watermarks, no subscriptions - just pure background removal power.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _checkForUpdate();
  }

  void _checkForUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1500), () async {
        if (!mounted || !context.mounted) return;
        try {
          await AppUpdateService.checkForUpdate(context);
        } catch (e) {
          debugPrint('⚠️ Error checking for app update: $e');
          // Silently fail - update check is not critical
        }
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _completeTutorial() async {
    if (!mounted) return;
    try {
      // Save tutorial completed flag
      await SharedPrefManager.setTutorialCompleted(true);
      // Navigate to home screen after tutorial completion
      if (context.mounted) {
        context.router.replace(const HomeRoute());
      }
    } catch (e) {
      debugPrint('⚠️ Error completing tutorial: $e');
      // Try to navigate anyway
      if (mounted && context.mounted) {
        try {
          context.router.replace(const HomeRoute());
        } catch (_) {
          debugPrint('❌ Navigation failed after tutorial completion');
        }
      }
    }
  }

  void _goToNextPage() {
    if (_currentPage < _tutorialPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeTutorial();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // PageView with tutorial screens
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _tutorialPages.length,
                itemBuilder: (context, index) {
                  return _buildTutorialPage(_tutorialPages[index]);
                },
              ),
            ),
            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_tutorialPages.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primaryCoral
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
            // Next/Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _goToNextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryCoral,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentPage == _tutorialPages.length - 1
                        ? 'Get Started'
                        : 'Next',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialPage(TutorialItem item) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Image section - static only
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
                child: Image.asset(
                  item.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.image, size: 50, color: Colors.grey),
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
            ),

            const SizedBox(height: 40),

            // Text section
            Column(
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    item.description,
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
          ],
        ),
      ),
    );
  }
}

class TutorialItem {
  final String imagePath;
  final String title;
  final String description;

  TutorialItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}
